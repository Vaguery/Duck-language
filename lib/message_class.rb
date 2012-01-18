
class Message < Closure
  
  def initialize(string)
    @closure = Proc.new {|receiver| receiver.__send__(string) }
    @needs = [string]
    @value = string.intern
  end
  
  
  def to_s
    ":#{@value}"
  end
  
  def do
    self
  end
  
  def grab(object)
    can_use?(object) ?
      @closure.curry[object] :
      self
  end
  
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end