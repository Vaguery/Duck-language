#encoding: utf-8

def int(value)
  Int.new(value)
end


module Duck
  class Int < Number
    def type_cast_result(arg, operator)
      arg.class == Decimal ?
        Decimal.new(arg.value.send(operator,self.value)) :
        Int.new(arg.value.send(operator,self.value))
    end
    
    def deep_copy
      Int.new(@value)
    end
  
    def to_s
      "#{@value}"
    end
  
    # DUCK METHODS
  
    duck_handle :+ do
      Closure.new(["neg"],"#{self.value} + ?") {|summand| type_cast_result(summand, :+)}
    end
  
  
    duck_handle :- do
      Closure.new(["neg"],"? - #{self.value}") {|arg1| type_cast_result(arg1, :-)}
    end
  
  
    duck_handle :* do
      Closure.new(["neg"], "#{self.value} * ?") {|multiplier| type_cast_result(multiplier, :*)}
    end
  
  
    duck_handle :÷ do
      if self.value != 0.0
        Closure.new(["neg"],"? ÷ #{self.value}") {|numerator| type_cast_result(numerator, :/)}
      else
        Closure.new(["neg"],"? ÷ #{self.value}") {|numerator| Error.new("DIV0")}
      end
    end
  
  
    duck_handle :bundle do
      @value.to_i < 1 ?
      List.new :
      Collector.new(@value.to_i,[])
    end
  
  
    duck_handle :copies do
      i = self.value
      Closure.new(["be"],"#{i} of ?") do |item|
        item.to_s.length * i <= @@result_size_limit ?
        i.times.collect {|i| item.clone} :
        Error.new("OVERSIZED RESULT")
      end
    end
  
  
    duck_handle :dec do
      Int.new @value - 1
    end
  
  
    duck_handle :inc do
      Int.new @value + 1
    end
    
    
    duck_handle :rand do
      case 
      when @value > 0
        Int.new Random.rand(@value)
      when @value == 0
        self
      else
        Int.new -Random.rand(@value.abs)
      end
    end
    
    
    duck_handle :to_bool do
      Bool.new(@value.to_i >= 0)
    end
  
  
    duck_handle :to_decimal do
      Decimal.new(@value.to_f)
    end
  end
end