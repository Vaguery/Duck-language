class StackItem
  attr_reader :value
  
  def initialize(value)
    @value = value
  end
  
  def disappear
    # no return item
  end
end


class IntegerItem < StackItem
end

class MessageItem < StackItem
end