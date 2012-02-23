#encoding: utf-8
module Duck
  
  def interpreter(args={})
    Interpreter.new(args)
  end
  
  class Interpreter < Assembler
    class << self; attr_accessor :global_ticks end
    @global_ticks = 0
  
  
    attr_accessor :script
    attr_accessor :ticks
    attr_accessor :max_ticks
    attr_accessor :greedy_flag
    attr_accessor :initial_script,:initial_contents,:initial_buffer,:initial_binder
    attr_accessor :binder
    attr_accessor :halted
    attr_accessor :trace
    attr_accessor :trace_string
    attr_accessor :staged_item
    
    def initialize(args = {})
      default_args = {
        script:"",
        contents:[],
        buffer:[],
        binder:Binder.new,
        halted:false,
        ticks:0,
        max_ticks:6000,
        greedy_flag:true}
      
      args = default_args.merge(args)
      
      @script = Script.new(args[:script])
      @initial_script = args[:script]
      
      @contents = args[:contents]
      @initial_contents = @contents.collect {|item| item.deep_copy}
      
      @buffer = args[:buffer]
      @initial_buffer = @buffer.collect {|item| item.deep_copy}
      
      parsed_binder = args[:binder].kind_of?(Hash) ? Binder.from_key_value_hash(args[:binder]) : args[:binder]
      @binder = parsed_binder
      @initial_binder = @binder.deep_copy
      replace_proxy_in_binder
      
      @halted = args[:halted]
      
      @ticks = args[:ticks]
      
      @max_ticks = args[:max_ticks]
      
      @greedy_flag = args[:greedy_flag]
      
      @needs = [] # whew
      
      @trace = false
      @trace_string = StringIO.new
    end
    
    def replace_proxy_in_binder
      @binder.contents = @binder.contents.delete_if {|item| item.kind_of?(Proxy)}
      @binder.contents.unshift Proxy.new(self)
    end
  
    def deep_copy
      result = Interpreter.new
      result.script = @script.deep_copy
      result.contents = @contents.collect {|i| i.deep_copy}
      result.buffer = @buffer.collect {|i| i.deep_copy}
      result.halted = @halted
      result.replace_proxy_in_binder
      
      result.initial_script = @initial_script
      result.initial_contents = @initial_contents
      result.initial_buffer = @initial_buffer
      result.ticks = @ticks
      result.max_ticks = @max_ticks
      result.greedy_flag = @greedy_flag
      result.trace = @trace
      result
    end
  
    def to_s
      rep = (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ")
      rep += @contents.empty? ? "::" : " ::"
      rep += (@buffer.inject(" ") {|s,i| s+i.to_s+", "}).chomp(", ") unless @buffer.empty?
      rep += " :: "
      rep += @script.to_s
      rep += "]"
    end
    
    
    def reset(opts = {})
      default_opts = {
        script: @initial_script, 
        contents: @initial_contents, 
        buffer: @initial_buffer, 
        binder: @initial_binder,
        ticks: 0,
        max_ticks: @max_ticks}
      
      opts = default_opts.merge(opts)
      
      @script = Script.new(opts[:script])
      @initial_script = opts[:script]
      
      @contents = opts[:contents]
      @initial_contents = opts[:contents]
      
      @buffer = opts[:buffer]
      @initial_buffer = opts[:buffer]
      
      parsed_binder = opts[:binder].kind_of?(Hash) ? 
        Binder.from_key_value_hash(opts[:binder]) : 
        opts[:binder]
      @binder = parsed_binder
      @initial_binder = parsed_binder
      replace_proxy_in_binder
      
      @halted = false
      @greedy_flag = true
      
      @ticks = opts[:ticks]
      @max_ticks = opts[:max_ticks]
      
      @trace_string = StringIO.new
      self
    end
    
    def proxy
      @binder.contents[0]
    end
    
    
    def next_token
      @buffer.push(@script.next_token) unless @script.empty?
      self.process_buffer unless @buffer.empty?
    end
    
    
    def unfinished?
      @ticks < @max_ticks && (@script.value.strip.length > 0 || @buffer.length > 0)
    end
    
    
    def next_contents_index_wanted_by(some_item)
      where_in_stack = @contents.rindex {|arg| some_item.can_use?(arg)}
      if where_in_stack.nil? && @binder.contains_an_arg_for?(some_item)
        where_in_stack = -1
      end
      where_in_stack
    end
    
    
    def rebuffer_result_when_staged_item_grabs(item)
      curried_result = @staged_item.grab(item)
      rebuffer_intermediate_result(curried_result) 
    end
    
    
    def trace!
      @trace = true
      self
    end
    
    
    def write_to_trace(text)
      puts text
      @trace_string.write(text + "\n")
    end
    
    
    def cartoon_of_state
      write_to_trace "Interpreter #{self.object_id} #{@ticks}/#{@max_ticks} : #{self.inspect}" 
    end
    
    
    def trace_staging
      write_to_trace "   #{@ticks}: staging the #{@staged_item.class} #{@staged_item.inspect}" unless @staged_item.nil?
    end
    
    
    def trace_used_as_arg(position)
      write_to_trace "   ... grabbed by #{@contents[position].class} #{@contents[position].inspect}" unless position.nil?
    end
    
    
    def trace_uses_arg(position)
      write_to_trace "   ... grabbed the #{@contents[position].class} #{@contents[position].inspect}" unless position.nil?
    end
    
    
    def trace_entire_buffer
      write_to_trace "   ... the buffer is now #{@buffer.inspect}"
    end
    
    
    
    def trace_pushed_item(item)
      write_to_trace "   ... #{item.class} #{item.inspect} was moved to contents"
    end
    
    
    def saved_trace
      @trace_string.string || ""
    end
    
    
    def process_next_buffer_item
      unless buffer.empty?
        count_a_tick
        @staged_item = @buffer.delete_at(0)
        trace_entire_buffer if @trace
        trace_staging if @trace
        next_arg_position = next_contents_index_wanted_by(@staged_item)
        if next_arg_position.nil? 
          wanted_by_position = next_contents_index_that_wants(@staged_item) if @greedy_flag
          trace_used_as_arg(wanted_by_position) if @trace
          if wanted_by_position.nil?
            @contents.push @staged_item
            trace_pushed_item(@staged_item) if @trace
          else
            rebuffer_result_when_staged_item_is_grabbed_by_contents_item_at wanted_by_position
          end
        elsif next_arg_position == -1
          arg_from_binder = @binder.produce_respondent(@staged_item.needs[0])
          rebuffer_result_when_staged_item_grabs arg_from_binder
        else
          trace_uses_arg(next_arg_position) if @trace
          rebuffer_result_when_staged_item_grabs_contents_item_at next_arg_position
        end
      end
    end
    
    
    # DUCK METHODS
    
    duck_handle :empty do
      @contents = []
      @buffer = []
      self
    end
    
    
    duck_handle :flatten do
      new_contents = @contents.inject([]) do |arr,item|
        case 
        when item.kind_of?(Assembler)
          arr + item.contents + item.buffer
        when item.kind_of?(List)
          arr + item.contents
        else
          arr << item
        end
      end
      @contents = new_contents
      self
    end
    
    
    duck_handle :reverse do
       @contents = @contents.reverse
       self
    end
  
  
    duck_handle :rotate do
      @contents = @contents.rotate(1)
      self
    end
  
  
    duck_handle :run do
      @staged_item = nil
      @halted = false
      while unfinished?
        cartoon_of_state if @trace
        next_token if @buffer.empty?
        process_buffer unless @buffer.empty?
      end
      cartoon_of_state if @trace
      self
    end
  
  
    duck_handle :shift do
      if @contents.empty?
        self
      else 
        item = @contents.shift
        [self,item]
      end
    end
    
    
    duck_handle :step do
      process_next_buffer_item
      self
    end
    
    
    duck_handle :to_assembler do
      Assembler.new(contents:[@script] + @contents, buffer:@buffer)
    end
    
    
    duck_handle :to_interpreter do
      self
    end
    
    
    duck_handle :to_binder do
      Binder.new([@script] + @contents + @buffer)
    end
    
    
    duck_handle :to_list do
      List.new([@script] + @contents + @buffer)
    end
  end
end