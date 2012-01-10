class StackItem < BasicObject
  attr_reader :value
  
  def initialize(value)
    @value = value
  end
end


class IntegerItem < StackItem
  
end

class MessageItem < StackItem
  
end