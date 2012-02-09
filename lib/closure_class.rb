#encoding: utf-8

class Closure < Item
  attr_reader  :needs, :value
  attr_accessor :closure,:string_version
  
  
  def initialize(needs=[], string = nil, &closure)
    @closure = closure
    @needs = needs
    string ||= template_string
    @string_version = string
    @value = self.to_s
    @returned_items_responses = []
  end
  
  
  def template_string
    unless @needs.empty?
      "f(" + "_,"*(needs.length-1) + "_)"
    else
      "f()"
    end
  end
  
  
  def grab(object)
    if self.can_use?(object)
      if @needs.length > 1
        new_needs = @needs.drop(1)
        result = Closure.new(new_needs)
        result.closure = @closure.curry[object] # this is a Ruby syntax workaround I am sorry about
        result
      else
        @closure.curry[object]
      end
    else
      self
    end
  end
  
  
  def zap
    nil
  end
  
  
  def to_s
    "λ(#{@string_version},#{@needs.inspect})"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:zap]
end