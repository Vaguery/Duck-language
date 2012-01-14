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
  def neg
    self.class.new(-@value)
  end
end


class Int < Number
  def +
    needs = ["neg"]
    Closure.new(Proc.new {|summand| Int.new(self.value + summand.value)},needs)
  end
end


class Closure < Item
  attr_reader :closure
  attr_reader :needs
  attr_reader :value
  
  def initialize(closure,needs)
    @value = nil
    @closure = closure
    @needs = needs
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
end
