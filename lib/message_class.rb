
class Message < Closure
  
  def initialize(string)
    @closure = Proc.new {|receiver| receiver.__send__(string) }
    @needs = [string]
    @value = string.intern
  end
  
  
  def to_s
    ":#{@value}"
  end
  
  def grab(object)
    can_use?(object) ?
      @closure.curry[object] :
      self
  end
  
  
  def do
    self
  end
  
  
  def eql
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value == self.value)},["do"],"? == #{self.value}")
  end
  
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + [:do, :eql]
end