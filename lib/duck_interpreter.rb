class DuckInterpreter
  attr_accessor :script
  attr_accessor :queue
  attr_accessor :stack
  attr_accessor :stage
  
  
  def initialize(script="")
    @script = script.strip
    @queue = []
    @stack = []
  end
  
  
  def run
    while @script.length > 0 || @queue.length > 0 || @stage
      step
    end
    self
  end
  
  
  def step
    parse if @queue.empty?
    
    next_item = @queue[0]
    
    @stack.push next_item
    
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
      Closure.new(Message.new(string),string,[],[string])
    end
  end
  
end