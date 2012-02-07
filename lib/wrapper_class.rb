#encoding: utf-8
class Wrapper < Closure
  attr_accessor :count
  attr_reader :limit
  
  def initialize(limit=(1.0/0), needs=["count","be"])
    @closure =
      Proc.new do |list,item|
        tick
        list.kind_of?(Assembler) ? list.push(item.deep_copy) : list.contents += [item.deep_copy]
        (@count < @limit) ? [list, self] : list
      end
    @limit=limit
    @needs=needs
    @string_version = "|"
    @count=0
  end
  
  def tick
    @count += 1
  end
  
  def to_s
    "|(?×#{@limit-@count})"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + []
end