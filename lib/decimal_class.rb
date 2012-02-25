#encoding: utf-8
module Duck
  def decimal(value)
    Decimal.new(value)
  end

  class Decimal < Number
    def to_s
      "#{@value}"
    end
  
    # DUCK METHODS
  
    duck_handle :+ do
      needs = ["neg"]
      Closure.new(needs,"#{self.value} + ?") {|summand| Decimal.new(self.value + summand.value)}
    end
  
  
    duck_handle :- do
      needs = ["neg"]
      Closure.new(needs,"? - #{self.value}") {|arg1| Decimal.new(arg1.value - self.value)}
    end
  
  
    duck_handle :* do
      needs = ["neg"]
      Closure.new(needs,"#{self.value} * ?") {|multiplier| Decimal.new(self.value * multiplier.value)}
    end
  
  
    duck_handle :÷ do
      needs = ["neg"]
      self.value != 0 ? 
        Closure.new(needs,"? ÷ #{self.value}") {|numerator| Decimal.new(numerator.value / self.value)}:
        Closure.new(needs,"? ÷ #{self.value}") {|numerator| Error.new("DIV0")}
    end
    
    
    duck_handle :ceiling do
      Decimal.new(@value.ceil)
    end
    
    
    duck_handle :count do
      Iterator.new(start:0.0, end:@value, inc:1.0,:response => :index).run
    end
    
    
    duck_handle :count_by do
      Closure.new(["neg"], "#{self.inspect}.count_by(?)") do |number|
        Iterator.new(start:0.0, end:@value, inc:number.value.to_f, :response => :index).run
      end
    end
    
    
    duck_handle :floor do
      Decimal.new(@value.floor)
    end
    
    
    duck_handle :rand do
      case 
      when @value > 0.0
        Decimal.new Random.rand * @value
      when @value == 0.0
        self
      else
        Decimal.new -Random.rand * @value.abs
      end
    end
  
  
    duck_handle :to_bool do
      Bool.new(@value.to_i >= 0.0)
    end
  
  
    duck_handle :to_int do
      Int.new(self.value.to_i)
    end
    
    
    duck_handle :to_span do
      Closure.new(["trunc"],"(#{self.inspect}..?)") do |float|
        Span.new(@value, float.value)
      end
    end
    
    
    duck_handle :trunc do
      [Int.new(self.value.to_i), Decimal.new(self.value-self.value.to_i)]
    end
  end
end