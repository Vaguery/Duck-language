class StackItem
  attr_reader :value
  
  def initialize(value)
    @value = value
  end
  
  def disappear
    []
    # no return item
  end
  
  def dup
    [self.clone,self.clone]
  end
end


class IntegerItem < StackItem
end

class MessageItem < StackItem
end