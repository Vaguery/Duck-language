#encoding: utf-8
class Decimal < Number
  def +
    needs = ["neg"]
    Closure.new(Proc.new {|summand| Decimal.new(self.value + summand.value)},needs,"#{self.value} + ?")
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|arg1| Decimal.new(arg1.value - self.value)},needs,"? - #{self.value}")
  end
  
  def *
    needs = ["neg"]
    Closure.new(Proc.new {|multiplier| Decimal.new(self.value * multiplier.value)},needs,"#{self.value} * ?")
  end
  
  def /
    needs = ["neg"]
    self.value != 0 ? 
      Closure.new(Proc.new {|numerator| Decimal.new(numerator.value / self.value)},needs,"? / #{self.value}") :
      Closure.new(Proc.new {|numerator| Error.new("DIV0")},needs,"? / #{self.value}")
  end
  
  def trunc
    [Int.new(self.value.to_i), Decimal.new(self.value-self.value.to_i)]
  end
  
  def to_int
    Int.new(self.value.to_i)
  end
  
  def to_bool
    Bool.new(@value.to_i >= 0.0)
  end
  
  
  def to_s
    "#{@value}"
  end
  
  # keep at end of class definition!
  @recognized_messages = Number.recognized_messages + [:+, :-, :*, :/, :trunc, :to_int, :to_bool]
end
