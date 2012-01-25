#encoding: utf-8
class Bool < Item
  
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
  
  def to_s
    "#{@value ? 'T' : 'F'}"
  end
  
  # keep at end of class definition!
  @private_messages = [:value, :needs, :messages, :grab, :recognize_message?, :can_use?, :to_s]
  @recognized_messages = (self.instance_methods - Object.instance_methods - @private_messages)
end