module Duck
  

  class Local < Message
    
    def local(string)
      Local.new(string)
    end
    
    
    def initialize(string)
      raise ArgumentError, "Local cannot be made from \"#{string}\" without leading underscore" unless
        string[0] == "_"
      super
    end
    
    def deep_copy
      Local.new(@value)
    end
    
    
    def to_s
      ":#{@value}"
    end
    
    # DUCK METHODS
    
    duck_handle :bind do
      Closure.new(["be"],"#{@value}.bind(?)") do |new_value|
        if new_value.value == @value
          Error.new("RECURSIVE VARIABLE")
        else
          Variable.new(@value, new_value)
        end
      end
    end
    
    
    duck_handle :rand do
      rand_chars = (@value.length-1).times.inject("") {|m,i| m+('a'..'z').to_a.sample}
      Local.new("_#{rand_chars}")
    end
  end
end