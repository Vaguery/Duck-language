#encoding: utf-8
class Decimal < Number
  def +
    needs = ["neg"]
    Closure.new(needs,"#{self.value} + ?") {|summand| Decimal.new(self.value + summand.value)}
  end
  
  def -
    needs = ["neg"]
    Closure.new(needs,"? - #{self.value}") {|arg1| Decimal.new(arg1.value - self.value)}
  end
  
  def *
    needs = ["neg"]
    Closure.new(needs,"#{self.value} * ?") {|multiplier| Decimal.new(self.value * multiplier.value)}
  end
  
  def ÷
    needs = ["neg"]
    self.value != 0 ? 
      Closure.new(needs,"? ÷ #{self.value}") {|numerator| Decimal.new(numerator.value / self.value)}:
      Closure.new(needs,"? ÷ #{self.value}") {|numerator| Error.new("DIV0")}
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
  @recognized_messages = Number.recognized_messages + [:+, :-, :*, :÷, :trunc, :to_int, :to_bool]
end
