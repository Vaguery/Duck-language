#encoding: utf-8


module Duck
  def variable(key, value)
    Variable.new(key,value)
  end
  
  
  class Variable < Item
    attr_reader :key
    attr_accessor :value
    
    
    def initialize(key, value)
      raise ArgumentError, "Variable key not a Symbol or String" unless
        [Symbol, String].include?(key.class)
      raise ArgumentError, "Variable value not a Duck::Item" unless
        value.kind_of?(Item)
      
      @key = key.intern
      @value = value
      @needs = []
      
      define_singleton_method @key do
        [self,@value.deep_copy]
      end
    end
    
    
    def deep_copy
      Variable.new(@key, @value)
    end
    
    
    def recognize_message?(string)
      signal = string.intern
      signal == @key || self.class.recognized_messages.include?(signal)
    end
    
    
    def to_s
      "#{@key.inspect}=#{@value.inspect}"
    end
    
    # DUCK METHODS  
    
    duck_handle :rebind do
      Closure.new(["be"],"#{@key}.bind(?)") {|new_value| Variable.new(@key, new_value)}
    end
    
    
    duck_handle :size do
      [self,Int.new(2 + @value.size[1].value)]
    end
  end
end