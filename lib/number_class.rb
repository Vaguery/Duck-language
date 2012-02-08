#encoding: utf-8
class Number < Item
  
  def neg
    self.class.new(-@value)
  end
  
  def <
    Closure.new(["neg"],"? < #{self.value}") {|arg1| Bool.new(arg1.value < self.value)}
  end
  
  def ≤
    Closure.new(["neg"],"? ≤ #{self.value}") {|arg1| Bool.new(arg1.value <= self.value)}
  end
  
  def ≥
    Closure.new(["neg"],"? ≥ #{self.value}") {|arg1| Bool.new(arg1.value >= self.value)}
  end
  
  def >
    Closure.new(["neg"],"? > #{self.value}") {|arg1| Bool.new(arg1.value > self.value)}
  end
  
  def eql
    Closure.new(["neg"],"? == #{self.value}") {|arg1| Bool.new(arg1.value == self.value)}
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:eql, :>, :<, :≥, :≤, :neg]
end



