#encoding:utf-8

class Item
  attr_reader :value
  attr_reader :needs
  attr_reader :messages
  
  def initialize(value="")
    @value = value
    @needs = []
  end  
  
  def grab(object)
    self
  end
  
  def recognize_message?(string)
    (self.class.instance_methods - Object.instance_methods).include?(string.intern)
  end
  
  def can_use?(object)
    !@needs.empty? && object.recognize_message?(@needs[0]) 
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
  
  def <
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value < self.value)},["neg"],"? < #{self.value}")
  end
  
  def ≤
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value <= self.value)},["neg"],"? ≤ #{self.value}")
  end
  
  def ≥
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value >= self.value)},["neg"],"? ≥ #{self.value}")
  end
  
  def >
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value > self.value)},["neg"],"? > #{self.value}")
  end
  
  def eql
    Closure.new(Proc.new {|arg1| Bool.new(arg1.value == self.value)},["neg"],"? == #{self.value}")
  end
end


class Int < Number
  def +
    needs = ["neg"]
    Closure.new(Proc.new {|summand| Int.new(self.value + summand.value)},needs,"#{self.value} + ?")
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|arg1| Int.new(arg1.value - self.value)},needs,"? - #{self.value}")
  end
  
  def *
    needs = ["neg"]
    Closure.new(Proc.new {|multiplier| Int.new(self.value * multiplier.value)},needs,"#{self.value} * ?")
  end
  
  def /
    needs = ["neg"]
    self.value != 0 ? 
      Closure.new(Proc.new {|numerator| Int.new(numerator.value / self.value)},needs,"? / #{self.value}") :
      Closure.new(Proc.new {|numerator| Int.new(@@divzero_result)},needs,"DIV0")
  end
  
  def inc
    Int.new(@value + 1)
  end
  
  def dec
    Int.new(@value - 1)
  end
  
  def to_s
    "#{@value}"
  end
end


class Bool < Item
  def to_s
    "#{@value ? 'T' : 'F'}"
  end
  
  def ¬
    Bool.new(!@value)
  end
  
  def ∧
    needs = ["¬"]
    Closure.new(Proc.new {|arg2| Bool.new(self.value && arg2.value)},needs,"#{self.value} ∧ ?")
  end
  
  def ∨
    needs = ["¬"]
    Closure.new(Proc.new {|arg2| Bool.new(self.value || arg2.value)},needs,"#{self.value} ∨ ?")
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
    "λ(#{@string_version},#{@needs.inspect})"
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
  
  def grab(object)
    can_use?(object) ?
      @closure.curry[object] :
      self
  end
end