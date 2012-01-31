#encoding: utf-8
class Error < Item
  
  def to_s
    "err:#{@value}"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + []
end