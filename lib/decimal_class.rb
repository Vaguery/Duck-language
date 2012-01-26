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
  
  # def *
  #   needs = ["neg"]
  #   Closure.new(Proc.new {|multiplier| Int.new(self.value * multiplier.value)},needs,"#{self.value} * ?")
  # end
  # 
  # def /
  #   needs = ["neg"]
  #   self.value != 0 ? 
  #     Closure.new(Proc.new {|numerator| Int.new(numerator.value / self.value)},needs,"? / #{self.value}") :
  #     Closure.new(Proc.new {|numerator| Int.new(@@divzero_result)},needs,"DIV0")
  # end
  # 
  # def inc
  #   Int.new(@value + 1)
  # end
  # 
  # def dec
  #   Int.new(@value - 1)
  # end
  # 
  # def copies
  #   i = self.value
  #   Closure.new(Proc.new {|item| i.times.collect {|i| item.clone}},["be"],"#{i} of ?")
  # end
  
  
  def to_s
    "#{@value}"
  end
  
  # keep at end of class definition!
  @recognized_messages = Number.recognized_messages + [:+, :-]
end
