class DuckInterpreter
  attr_accessor :script
  attr_accessor :queue
  attr_accessor :stack
  attr_accessor :staged_item
  
  
  def initialize(script="")
    @script = script.strip
    @queue = []
    @stack = []
  end
  
  
  def run
    while @script.length > 0 || @queue.length > 0
      step
    end
    self
  end
  
  
  def parse
    leader,token,@script = @script.partition(/\S+\s*/)
    @queue.push recognize(token.strip)
    self
  end
  
  
  def recognize(string)
    case string
    when /^[-+]?[0-9]+$/
      Int.new(string.to_i)
    else
      Message.new(string)
    end
  end
  
  
  def step
    parse if @queue.empty?
    unless @queue.empty?
      @staged_item = @queue.delete_at(0)
      fill_staged_item_needs if @staged_item
      consume_staged_item_as_arg if @staged_item
      check_for_interpreter_response if @staged_item
      if @staged_item
        @stack.push @staged_item
        @staged_item = nil
      end
    end
    self
  end
  
  
  def fill_staged_item_needs
    while next_arg = @stack.rindex {|item| @staged_item.can_use?(item)}
      @staged_item = @staged_item.grab(@stack.delete_at(next_arg))
    end
  end
    
  
  def consume_staged_item_as_arg
    if arg_for = @stack.rindex {|item| item.can_use?(@staged_item)}
      @queue.unshift( @stack[arg_for].grab(@staged_item))
      @stack.delete_at(arg_for)
      @staged_item = nil
    end
  end
  
  
  def check_for_interpreter_response
    if @staged_item.kind_of?(Message)
      if self.respond_to?(@staged_item.value)
        self.__send__(@staged_item.value)
        @staged_item = nil
      end
    end
  end
  
  
  def depth
    @stack.push Int.new(@stack.length)
  end
end