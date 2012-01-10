class DuckInterpreter
  attr_accessor :script
  attr_accessor :queue
  attr_accessor :stack
  
  
  def initialize(script="")
    @script = script.strip
    @queue = []
    @stack = []
  end
  
  
  def run
    while @script.length > 0
      step
    end
    self
  end
  
  
  def step
    parse
    next_item = @queue[0]
    
    if next_item.kind_of?(MessageItem)
      msg_text = next_item.value
      recipient = @stack.rindex{|item| item.respond_to?(msg_text)}
      if recipient
        result = @stack.delete_at(recipient).instance_eval(msg_text)
        @queue.push result if result
        @queue.delete_at(0)
      end
    end
    @stack.push @queue.delete_at(0) if @queue[0]
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
      IntegerItem.new(string.to_i)
    else
      MessageItem.new(string)
    end
  end
  
end