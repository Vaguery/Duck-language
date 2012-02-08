#encoding: utf-8
class Int < Number
  def type_cast_result(arg, operator)
    arg.class == Decimal ?
      Decimal.new(arg.value.send(operator,self.value)) :
      Int.new(arg.value.send(operator,self.value))
  end
  
  
  def +
    Closure.new(["neg"],"#{self.value} + ?") {|summand| type_cast_result(summand, :+)}
  end
  
  
  def -
    Closure.new(["neg"],"? - #{self.value}") {|arg1| type_cast_result(arg1, :-)}
  end
  
  
  def *
    Closure.new(["neg"], "#{self.value} * ?") {|multiplier| type_cast_result(multiplier, :*)}
  end
  
  
  def ÷
    if self.value != 0.0
      Closure.new(["neg"],"? ÷ #{self.value}") {|numerator| type_cast_result(numerator, :/)}
    else
      Closure.new(["neg"],"? ÷ #{self.value}") {|numerator| Error.new("DIV0")}
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
    Closure.new(["be"],"#{i} of ?") do |item|
      item.to_s.length * i <= @@result_size_limit ?
      i.times.collect {|i| item.clone} :
      Error.new("OVERSIZED RESULT")
    end
  end
  
  def bundle
    @value.to_i < 1 ?
    List.new :
    Collector.new(@value.to_i,[])
  end
  
  def to_decimal
    Decimal.new(@value.to_f)
  end
  
  def to_bool
    Bool.new(@value.to_i >= 0)
  end
  
  def to_s
    "#{@value}"
  end
  
  # keep at end of class definition!
  @recognized_messages = Number.recognized_messages + [:-, :*, :+, :÷, :inc, :dec, :copies, :bundle, :to_bool, :to_decimal]
end
