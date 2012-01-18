#encoding:utf-8
class DuckInterpreter
  class << self; attr_accessor :recognized_messages end
  
  attr_reader :old_script,:old_bindings
  attr_accessor :script
  attr_accessor :queue
  attr_accessor :stack
  attr_accessor :staged_item
  attr_accessor :bindings
  attr_accessor :greedy_flag
  
  
  def initialize(script="",bindings={})
    @script = script.strip
    @old_script = @script
    
    @bindings = bindings
    @old_bindings = bindings.clone
    
    @queue = []
    @stack = []
    @staged_item = nil
    
    @greedy_flag = true
  end
  
  
  def reset(script=@old_script,bindings=@old_bindings)
    @script = script
    @bindings = bindings
    @queue = []
    @stack = []
    @staged_item = nil
    @greedy_flag = true
    self
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
    when 'true','T'
      Bool.new(true)
    when 'false','F'
      Bool.new(false)
    else
      Message.new(string)
    end
  end
  
  
  def step
    parse if @queue.empty?
    unless @queue.empty?
      @staged_item = @queue.delete_at(0)
      fill_staged_item_needs if @staged_item
      consume_staged_item_as_arg if (@staged_item && @greedy_flag)
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
      place_intermediate_result @staged_item.grab(@stack.delete_at(next_arg))
    end
  end
  
  
  def place_intermediate_result(returned_item)
    unless returned_item.kind_of?(Array)
      @staged_item = returned_item
    else
      @staged_item = returned_item.delete_at(0)
      @queue = returned_item + @queue
    end
  end
  
  
  def consume_staged_item_as_arg
    if arg_for = @stack.rindex {|item| item.can_use?(@staged_item)}
      place_intermediate_result @stack[arg_for].grab(@staged_item)
      @stack.delete_at(arg_for)
      @queue.unshift @staged_item.clone
      @staged_item = nil
    end
  end
  
  
  def recognize_message?(string)
    DuckInterpreter.recognized_messages.include?(string.intern)
  end
  
  
  def check_for_interpreter_response
    msg = @staged_item.value.to_s
    if @staged_item.kind_of?(Message)
      if @bindings[msg]
        @queue.unshift @bindings[msg]
        @staged_item = nil
      elsif self.recognize_message?(msg)
        self.__send__(msg)
        @staged_item = nil
      end
    end
  end
  
  
  def greedy?
    @queue.unshift Bool.new(@greedy_flag)
  end
  
  
  def greedy
    @greedy_flag = true
  end
  
  
  def ungreedy
    @greedy_flag = false
  end
  
  
  def depth
    @stack.push Int.new(@stack.length)
  end
  
  
  def quote
    if @queue.empty? && @script.length > 0
      leader,token,@script = @script.partition(/\S+\s*/)
      @queue.push recognize(token.strip)
    end
    @stack.push @queue.shift unless queue.empty? 
  end
  
  
  def pop
    @stack.pop
  end
  
  
  def swap
    @stack[-1],@stack[-2] = @stack[-2],@stack[-1] if @stack.length > 1
  end
  
  def copy
    @stack.push(@stack[-1].clone) unless @stack.empty?
  end
  
  def noop
    # black hole
  end
  
  # this line needs to follow all method definitions
  @recognized_messages = (self.instance_methods - Object.instance_methods) 
end