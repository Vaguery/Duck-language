#encoding: utf-8

class Closure < Item
  attr_reader :closure, :needs, :value
  attr_accessor :string_version
  
  
  def initialize(closure,needs,string = nil)
    @closure = closure
    @needs = needs
    string ||= template_string
    @string_version = string
    @value = self.to_s
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
        Closure.new(@closure.curry[object],@needs.drop(1))
      else
        @closure.curry[object]
      end
    else
      self
    end
  end
  
  
  def to_s
    "λ(#{@string_version},#{@needs.inspect})"
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end