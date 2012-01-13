# "1 +"
#   1.+(missing("neg"))  -> 1.+(arg)

class Closure
  attr_reader :proc
  attr_reader :needs
  
  def initialize(proc,needs)
    @proc = proc
    @needs = needs
  end
  
  def can_use?(object)
    object.respond_to?(@needs[0])
  end
  
  def grab(object)
    if can_use?(object)
      unless @needs.empty?
        Closure.new(@proc.curry[object],@needs.drop(1))
      else
        @proc.curry[object]
      end
    else
      self
    end
  end
end


class MyInt
  attr_reader :value
  def initialize(value)
    @value = value
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|b| MyInt.new(b.value - self.value)},needs)
  end
  
  def sum3
    needs = ["neg","neg"]
    Closure.new(Proc.new {|b,c| MyInt.new(b.value + c.value + self.value)},needs)
  end
  
  def neg
    MyInt.new(-@value)
  end
  
  def grab(object)
    self
  end
end




aa = MyInt.new(8)
bb = MyInt.new(5)

cc = aa.-
puts cc.can_use?(:foo)
puts cc.can_use?(bb)

puts cc.grab(bb).inspect


dd = aa.sum3
puts dd.can_use?(bb)
puts dd.grab(bb).inspect

puts aa.grab(cc).inspect
