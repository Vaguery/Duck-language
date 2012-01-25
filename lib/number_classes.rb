#encoding: utf-8
class Number < Item
  @@divzero_result = 0
  
  def self.divzero_result=(new_value)
    @@divzero_result=new_value
  end
  
  def neg
    self.class.new(-@value)
  end
  
  def <
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value < self.value)},["neg"],"? < #{self.value}")
  end
  
  def ≤
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value <= self.value)},["neg"],"? ≤ #{self.value}")
  end
  
  def ≥
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value >= self.value)},["neg"],"? ≥ #{self.value}")
  end
  
  def >
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value > self.value)},["neg"],"? > #{self.value}")
  end
  
  def eql
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value == self.value)},["neg"],"? == #{self.value}")
  end
  
  # keep at end of class definition!
  @private_messages = [:value, :needs, :messages, :grab, :recognize_message?, :can_use?, :to_s]
  @recognized_messages = (self.instance_methods - Object.instance_methods - @private_messages)
end


class Int < Number
  def +
    needs = ["neg"]
    Closure.new(Proc.new {|summand| Int.new(self.value + summand.value)},needs,"#{self.value} + ?")
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|arg1| Int.new(arg1.value - self.value)},needs,"? - #{self.value}")
  end
  
  def *
    needs = ["neg"]
    Closure.new(Proc.new {|multiplier| Int.new(self.value * multiplier.value)},needs,"#{self.value} * ?")
  end
  
  def /
    needs = ["neg"]
    self.value != 0 ? 
      Closure.new(Proc.new {|numerator| Int.new(numerator.value / self.value)},needs,"? / #{self.value}") :
      Closure.new(Proc.new {|numerator| Int.new(@@divzero_result)},needs,"DIV0")
  end
  
  def inc
    Int.new(@value + 1)
  end
  
  def dec
    Int.new(@value - 1)
  end
  
  def copies
    i = self.value
    Closure.new(Proc.new {|item| i.times.collect {|i| item.clone}},["be"],"#{i} of ?")
  end
  
  
  def to_s
    "#{@value}"
  end
  
  # keep at end of class definition!
  @private_messages = [:value, :needs, :messages, :grab, :recognize_message?, :can_use?, :to_s, :closure]
  @recognized_messages = (self.instance_methods - Object.instance_methods - @private_messages)
end
