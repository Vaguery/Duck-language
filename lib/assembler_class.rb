#encoding: utf-8
module Duck
  
  def assembler(args = {})
    Assembler.new(args)
  end
  
  class Assembler < List
    # superclass has @contents
    attr_accessor :buffer
    attr_accessor :halted
    attr_accessor :ticks
    attr_accessor :max_ticks
    attr_accessor :greedy_flag
    attr_accessor :staged_item
    
    
    def initialize(args = {})
      default_args = {
        contents:[],
        buffer:[]
      }
      args = default_args.merge(args)
      @contents = args[:contents]
      @buffer = args[:buffer]
      @needs = []
      @ticks = 0
      @max_ticks = 6000
      @halted = false
      @greedy_flag = true
    end
    
    
    def deep_copy
      new_contents = @contents.collect {|i| i.deep_copy}
      new_buffer = @buffer.collect {|i| i.deep_copy}
      result = self.class.new(contents:new_contents, buffer:new_buffer)
      result.halted = @halted
      result.ticks = @ticks
      result.max_ticks = @max_ticks
      result
    end
    
    
    def next_contents_index_wanted_by(some_item)
      @contents.rindex {|arg| some_item.can_use?(arg)}
    end
    
    
    def next_contents_index_that_wants(some_item)
      @contents.rindex {|arg| arg.can_use?(some_item)}
    end
    
    
    def rebuffer_intermediate_result(result)
      case
      when result.kind_of?(Array)
        @buffer = result.compact + @buffer
      when result.nil?
        # do nothing
      else
        @buffer.unshift(result)
      end
    end
    
    
    def process_buffer
      until @buffer.empty? || @halted
        process_next_buffer_item
      end
    end
    
    
    def count_a_tick
      @ticks += 1
      if @ticks > @max_ticks
        @staged_item = Error.new("over-complex: #{@ticks} ticks")
        @halted = true
      end
    end
    
    
    def rebuffer_result_when_staged_item_grabs_contents_item_at(position)
      count_a_tick
      curried_result = @staged_item.grab(@contents.delete_at(position))
      rebuffer_intermediate_result(curried_result)
    end
    
    
    def rebuffer_result_when_staged_item_is_grabbed_by_contents_item_at(position)
      count_a_tick
      curried_result = @contents.delete_at(position).grab(@staged_item)
      rebuffer_intermediate_result(curried_result)
    end
    
    
    def process_next_buffer_item
      unless @buffer.empty?
        @staged_item = @buffer.delete_at(0)
        count_a_tick
        next_arg_position = next_contents_index_wanted_by(@staged_item)
        if next_arg_position.nil?
          wanted_by_position = @greedy_flag ? next_contents_index_that_wants(@staged_item) : nil
          if wanted_by_position.nil?
            @contents.push @staged_item
          else
            rebuffer_result_when_staged_item_is_grabbed_by_contents_item_at wanted_by_position
          end
        else
          rebuffer_result_when_staged_item_grabs_contents_item_at next_arg_position
        end
      end
    end
    
    
    def to_s
      rep = (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ")
      rep += @contents.empty? ? "::" : " ::"
      rep += (@buffer.inject(" ") {|s,i| s+i.to_s+", "}).chomp(", ") unless @buffer.empty?
      rep += "]"
    end
    
    
    #  DUCK MESSAGES
    
    duck_handle :[] do
      Closure.new(["inc"], "#{self.to_s}[?]") do |idx| 
        index = idx.value.to_i
        how_many = @contents.length + @buffer.length
        which = how_many == 0 ? 0 : index % how_many
        unless how_many == 0
          if which < @contents.length
            self.contents[which].deep_copy
          else
            self.buffer[which-@contents.length].deep_copy
          end
        end
      end
    end
    
    duck_handle :[]= do
      Closure.new(['inc'], "(#{self.inspect}[?2] = ?1)") do |index|
        Closure.new(['be'],"(#{self.inspect}[#{index}] = ?1)") do |new_item|
          results = (@contents+@buffer).collect {|i| i.deep_copy}
          idx = index.value.to_i
          which = (results.length == 0) ? 0 : (idx % results.length)
          results[which] = new_item.deep_copy
          @contents = results[0...@contents.length]
          @buffer = results[@contents.length..results.length]
          self
        end
      end 
    end
    
    
    duck_handle :+ do
      Closure.new(["shatter"],"#{self.value} + ?") do |arg|
        @contents += arg.contents
        @buffer += (arg.respond_to?(:buffer) ? arg.buffer : [])
        self
      end
    end
    
    
    duck_handle :∩ do
      Closure.new(["shatter"],"#{self.inspect} ∩ ?") do |arg|
        other_contents = arg.contents.collect {|item| item.inspect}
        other_buffer = arg.respond_to?(:buffer) ? arg.buffer.collect {|item| item.inspect} : []
        @contents = @contents.select {|element| other_contents.include? element.inspect}
        @buffer = @buffer.select {|element| other_buffer.include? element.inspect}
        Assembler.new(contents:@contents, buffer:@buffer)
      end
    end
    
    
    duck_handle :∪ do
      Closure.new(["shatter"],"#{self.inspect} ∪ ?") do |arg|
        combined_contents = arg.contents + @contents
        combined_buffers = (arg.respond_to?(:buffer) ? arg.buffer : []) + @buffer
        @contents = combined_contents.uniq {|element| element.inspect}
        @buffer = combined_buffers.uniq {|element| element.inspect}
        Assembler.new(contents:@contents, buffer:@buffer)
      end
    end
    
    
    duck_handle :empty do
      @contents = []
      @buffer = []
      self
    end
    
    
    duck_handle :flatten do
      new_contents = @contents.inject([]) do |arr,item|
        case 
        when item.kind_of?(Interpreter)
          arr + [item.binder] + item.contents + item.buffer + [item.script]
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
    
    
    duck_handle :give do
      Closure.new(["be"],"give(#{self.inspect}, ?)") do |item|
        results = (@contents+@buffer).collect {|i| i.grab(item.deep_copy)}.flatten.compact
        List.new results
      end
    end
    
    
    duck_handle :greedy do
      @greedy_flag = true
      self
    end
    
    
    duck_handle :greedy? do
      Bool.new @greedy_flag
    end
    
    
    duck_handle :halt do
      @halted = true
      self
    end
    
    
    duck_handle :length do
      Int.new (@contents + @buffer).length
    end
    
    
    duck_handle :map do
      Closure.new(["be"],"map(#{self.inspect}, ?)") do |item|
        results = (@contents+@buffer).collect {|i| item.deep_copy.grab(i)}.flatten.compact
        size = results.inject("") {|rep,i| rep+(i.to_s)}.length
        size < @@result_size_limit ? List.new(results) : Error.new("OVERSIZE")
      end
    end
    
    
    duck_handle :pop do
      if @contents.empty?
        self
      else
        item = @contents.pop
        return [self,item]
      end
    end
    
    
    duck_handle :push do
      Closure.new(["be"],"#{self.to_s}.push(?)") do |item|
        result = self.deep_copy
        result.buffer << item.deep_copy
        result.process_buffer
        result
      end
    end
    
    
    duck_handle :reverse do
       @contents = @contents.reverse
       self
    end
    
    
    duck_handle :rewrap_by do
      Closure.new(["inc"],"rewrap#{self.inspect} by ?") do |size|
        slice_size = size.value.to_i
        slice_size = @contents.length if slice_size < 1
        if @contents.empty?
          result = self
        else
          result = @contents.each_slice(slice_size).collect {|chunk| self.class.new(contents:chunk)}
          result[-1].buffer = @buffer
        end
        result
      end
    end
    
    
    duck_handle :rotate do
      @contents = @contents.rotate(1)
      self
    end
    
    
    duck_handle :run do
      @halted = false
      self.process_buffer
      self
    end
    
    
    duck_handle :shatter do
      @contents + @buffer
    end
    
    
    duck_handle :shift do
      if @contents.empty?
        self
      else
        released_item = @contents.delete_at(0)
        [self,released_item]
      end
    end
    
    
    duck_handle :snap do
      Closure.new(["inc"],"snap#{self.inspect} at ?") do |location|
        if @contents.length > 0
          where = location.value.to_i % @contents.length
          [self.class.new(contents:@contents[0...where],buffer:[]),
            self.class.new(contents:@contents[where..-1],buffer:@buffer)]
        else
          self
        end
      end
    end
    
    
    duck_handle :step do
      process_next_buffer_item
      self
    end
    
    
    duck_handle :to_binder do
      Binder.new @contents+@buffer
    end
    
    
    duck_handle :to_list do
      List.new @contents+@buffer
    end
    
    
    duck_handle :to_interpreter do
      Interpreter.new contents:@contents, buffer:@buffer
    end
    
    
    duck_handle :ungreedy do
      @greedy_flag = false
      self
    end
    
    
    duck_handle :unshift do
      Closure.new(["be"],"#{self.to_s}.unshift(?)") do |item|
        @contents.unshift item.deep_copy
        self
      end
    end
    
    
    duck_handle :useful do
      Closure.new(["be"],"#useful({self.inspect}, ?)") do |item|
        results = (@contents+@buffer).group_by {|element| item.can_use?(element) ? "useful" : "unuseful"}
        [List.new(results["useful"]||[]), List.new(results["unuseful"]||[])]
      end
    end
    
    
    duck_handle :users do
      Closure.new(["be"],"#users({self.inspect}, ?)") do |item|
        results = (@contents+@buffer).group_by {|element| element.can_use?(item) ? "users" : "nonusers"}
        [List.new(results["users"]||[]), List.new(results["nonusers"]||[])]
      end
    end
  end
end