#encoding: utf-8
module Duck
  
  
  class T; end
  
  class F; end  
  
  def bool(value)
    value = true if value == T
    value = false if value == F
    Bool.new(value)
  end
  
  
  class Bool < Item
    def deep_copy
      Bool.new(@value)
    end
  
  
    def to_s
      "#{@value ? 'T' : 'F'}"
    end
  
    # DUCK METHODS
  
    duck_handle :¬ do
      Bool.new(!@value)
    end
  
  
    duck_handle :∧ do
      needs = ["¬"]
      Closure.new(needs,"#{self.value} ∧ ?") {|arg2| Bool.new(self.value && arg2.value)}
    end
  
    duck_handle :∨ do
      needs = ["¬"]
      Closure.new(needs,"#{self.value} ∨ ?") {|arg2| Bool.new(self.value || arg2.value)}
    end
    
    
    duck_handle :rand do
      Bool.new(Random.rand() < 0.5 ? false : true)
    end
    
    
    duck_handle :to_decimal do
      Decimal.new(@value ? 1.0 : 0.0)
    end
  
  
    duck_handle :to_int do
      Int.new(@value ? 1 : 0)
    end
    
    
    duck_handle :to_script do
      Script.new(@value ? 'T' : 'F')
    end
  end
end