#encoding: utf-8
class Number < Item
  
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
  @recognized_messages = Item.recognized_messages + [:eql, :>, :<, :≥, :≤, :neg]
end



class Int < Number
  def type_cast_result(arg, operator)
    arg.class == Decimal ?
      Decimal.new(arg.value.send(operator,self.value)) :
      Int.new(arg.value.send(operator,self.value))
  end
  
  
  def +
    Closure.new(
      Proc.new {|summand| type_cast_result(summand, :+)},
      ["neg"],
      "#{self.value} + ?")
  end
  
  
  def -
    Closure.new(
      Proc.new {|arg1| type_cast_result(arg1, :-)},
      ["neg"],
      "? - #{self.value}")
  end
  
  
  def *
    Closure.new(
      Proc.new {|multiplier| type_cast_result(multiplier, :*)},
      ["neg"],
      "#{self.value} * ?")
  end
  
  
  def /
    if self.value != 0.0
      Closure.new(
        Proc.new {|numerator| type_cast_result(numerator, :/)},
        ["neg"],
        "? / #{self.value}")
    else
      Closure.new(Proc.new {|numerator| Error.new("DIV0")},["neg"],"? / #{self.value}")
    end
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
  @recognized_messages = Number.recognized_messages + [:-, :*, :+, :/, :inc, :dec] # commented out :copies
end
