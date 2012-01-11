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


class NumericItem < StackItem
end


class IntegerItem < NumericItem
  def to_s
    "int(#{self.value})"
  end
  
  def add
    [ClosureItem.new(self,"+",[],["neg"])]
  end
end


class ClosureItem < StackItem
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


class MessageItem < StackItem
end