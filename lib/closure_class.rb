#encoding: utf-8

class Closure < Item
  attr_reader :closure, :needs, :value
  attr_accessor :string_version
  
  
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
      "f(" + "*,"*(needs.length-1) + "*)"
    else
      "f()"
    end
  end
  
  
  def grab(object)
    if can_use?(object)
      if @needs.length > 1
        Closure.new(@needs.drop(1)) {@closure.curry[object]}
      else
        @closure
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