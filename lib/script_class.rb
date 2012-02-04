#encoding: utf-8
class Script < Item
  attr_accessor :value
  
  def init(value="")
    @value = value
  end
    
  def lowercase
    Script.new(@value.downcase)
  end
  
  def to_s
    "«#{self.value}»"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:lowercase]
end