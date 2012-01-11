class StackItem
  attr_reader :value
  
  def initialize(value="")
    @value = value
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
  attr_accessor :args
  attr_accessor :needs
  
  def initialize(actor,method,args,needs)
    @actor=actor
    @method=method
    @args=args
    @needs=needs
  end
  
  def to_s
    "closure(#{actor.to_s},\"#{method}\",#{args.inspect},#{needs.inspect})"
  end
end


class Message < StackItem
end