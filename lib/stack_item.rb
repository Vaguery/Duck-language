class StackItem
  attr_reader :value
  attr_accessor :arguments
  attr_accessor :needs
  
  def initialize(value="")
    @value = value
    @arguments = []
    @needs = []
  end
  
  def disappear
    []
    # no return item
  end
  
  def dup
    [self.clone,self.clone]
  end
  
  def to_s
    "object(#{value})"
  end
  
  def want?(object)
    @needs.index{|need| object.respond_to?(need)}
  end
end


class Number < StackItem
end


class Int < Number
  def to_s
    "int(#{self.value})"
  end
  
  def add
    [Closure.new(self,"+",[],["neg"])]
  end
end


class Closure < StackItem
  attr_reader :actor
  attr_reader :method
  
  def initialize(actor,method,args,needs)
    @actor=actor
    @method=method
    @arguments=args
    @needs=needs
  end
  
  def to_s
    "closure(#{actor.to_s},\"#{method}\",#{arguments.inspect},#{needs.inspect})"
  end
end


class Message < StackItem
end