#encoding: utf-8
class Bool < Item
  def to_s
    "#{@value ? 'T' : 'F'}"
  end
  
  def ¬
    Bool.new(!@value)
  end
  
  def ∧
    needs = ["¬"]
    Closure.new(Proc.new {|arg2| Bool.new(self.value && arg2.value)},needs,"#{self.value} ∧ ?")
  end
  
  def ∨
    needs = ["¬"]
    Closure.new(Proc.new {|arg2| Bool.new(self.value || arg2.value)},needs,"#{self.value} ∨ ?")
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end