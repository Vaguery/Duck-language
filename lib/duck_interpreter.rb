class DuckInterpreter
  attr_accessor :script
  attr_accessor :queue
  attr_accessor :stack
  
  
  def initialize(script="")
    @script = script.strip
    @queue = []
    @stack = []
  end
  
  
  def step
    parse
    @stack.push @queue.shift
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