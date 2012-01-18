class Bundle < Item
  attr_accessor :contents
  
  def initialize(*items)
    @contents = items
    @needs = []
  end
  
  def shatter
    @contents
  end
  
  def count
    Int.new(@contents.length)
  end
  
  def to_s
    (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ")"
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end
