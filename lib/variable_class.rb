#encoding: utf-8
class Variable < Item
  attr_reader :key
  attr_accessor :value
  
  def initialize(key, value)
    @key = key.intern
    @value = value
    @needs = []
    
    define_singleton_method @key do
      [self,@value.deep_copy]
    end
  end
  
  def recognize_message?(string)
    signal = string.intern
    signal == @key || self.class.recognized_messages.include?(signal)
  end
  
  def to_s
    "#{@key.inspect}=#{@value.inspect}"
  end
  
  ####
  #
  # public duck methods
  #
  ####
  
  
  def rebind
    Closure.new(
      Proc.new {|new_value| Variable.new(@key, new_value)},
      ["be"],
      "#{@key}.bind(?)"
    )
  end
  
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:rebind]
end