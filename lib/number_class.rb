#encoding: utf-8
module Duck
  class Number < Item
    duck_handle :< do
      Closure.new(["neg"],"? < #{self.value}") {|arg1| Bool.new(arg1.value < self.value)}
    end
  
  
    duck_handle :≤ do
      Closure.new(["neg"],"? ≤ #{self.value}") {|arg1| Bool.new(arg1.value <= self.value)}
    end
  
  
    duck_handle :≥ do
      Closure.new(["neg"],"? ≥ #{self.value}") {|arg1| Bool.new(arg1.value >= self.value)}
    end
  
  
    duck_handle :> do
      Closure.new(["neg"],"? > #{self.value}") {|arg1| Bool.new(arg1.value > self.value)}
    end
  
  
    duck_handle :eql do
      Closure.new(["neg"],"? == #{self.value}") {|arg1| Bool.new(arg1.value == self.value)}
    end
  
  
    duck_handle :neg do
      self.class.new(-@value)
    end
  end
end
