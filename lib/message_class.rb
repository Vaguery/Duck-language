
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
  
  #############
  #
  # PUBLIC DUCK METHODS
  #
  ###############
  
  
  def do
    self
  end
  
  def bind
    Closure.new(["be"],"#{@value}.bind(?)") {|new_value| Variable.new(@value, new_value)}
  end
  
  def eql
    Closure.new(["do"],"? == #{self.value}") {|arg1| Bool.new(arg1.value == self.value)}
  end
  
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + [:do, :eql, :bind]
end