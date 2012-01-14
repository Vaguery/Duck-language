class Item
  attr_reader :value
  attr_reader :needs
  
  def initialize(value="")
    @value = value
    @needs = []
  end
  
  
  def grab(object)
    self
  end
  
  
  def can_use?(object)
    !@needs.empty? && object.respond_to?(@needs[0]) 
  end
  
  
  def to_s
    "#{self.class.to_s.downcase}(#{value})"
  end
end


class Number < Item
  @@divzero_result = 0
  
  def self.divzero_result=(new_value)
    @@divzero_result=new_value
  end
  
  def neg
    self.class.new(-@value)
  end
end


class Int < Number
  def +
    needs = ["neg"]
    Closure.new(Proc.new {|summand| Int.new(self.value + summand.value)},needs)
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|arg1| Int.new(arg1.value - self.value)},needs)
  end
  
  def *
    needs = ["neg"]
    Closure.new(Proc.new {|multiplier| Int.new(self.value * multiplier.value)},needs)
  end
  
  def /
    needs = ["neg"]
    self.value != 0 ? 
      Closure.new(Proc.new {|numerator| Int.new(numerator.value / self.value)},needs) :
      Closure.new(Proc.new {|numerator| Int.new(@@divzero_result)},needs)
  end
end


class Closure < Item
  attr_reader :closure, :needs, :value
  attr_accessor :string_version
  
  
  def initialize(closure,needs,string = nil)
    @closure = closure
    @needs = needs
    string ||= template_string
    @string_version = string
    @value = self.to_s
  end
  
  
  def template_string
    unless @needs.empty?
      "f(" + "*,"*(needs.length-1) + "*)"
    else
      "f()"
    end
  end
  
  
  def grab(object)
    if can_use?(object)
      if @needs.length > 1
        Closure.new(@closure.curry[object],@needs.drop(1))
      else
        @closure.curry[object]
      end
    else
      self
    end
  end
  
  
  def to_s
    "closure(#{@string_version},#{@needs.inspect})"
  end
end


class Message < Closure
  
  def initialize(string)
    @closure = Proc.new {|receiver| receiver.__send__(string) }
    @needs = [string]
    @value = string.intern
  end
  
  def to_s
    ":#{@value}"
  end
end