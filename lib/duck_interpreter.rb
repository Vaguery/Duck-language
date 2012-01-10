class DuckInterpreter
  attr_accessor :script
  attr_accessor :queue
  
  def initialize(script="")
    @script = script.strip
    @queue = []
  end
  
  
  def parse
    leader,token,@script = @script.partition(/\S+\s*/)
    @queue.push token.strip
    self
  end
  
end