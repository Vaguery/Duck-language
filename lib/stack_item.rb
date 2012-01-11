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
    "#{self.class}(#{value})"
  end
end


class NumericItem < StackItem
end


class IntegerItem < NumericItem
  def add
    [ClosureItem.new("add")]
  end
end


class ClosureItem < StackItem
end


class MessageItem < StackItem
end