#encoding:utf-8
class Item
  class << self; attr_accessor :recognized_messages end
  
  @@result_size_limit = 5000
  
  attr_reader :value
  attr_reader :needs
  attr_reader :messages
  
  
  def initialize(value="")
    @value = value
    @needs = []
  end
  
  def deep_copy
    self.clone
  end
  
  def grab(object)
    self
  end
  
  def recognize_message?(string)
    self.class.recognized_messages.include?(string.intern)
  end
  
  def can_use?(object)
    !@needs.empty? && object.recognize_message?(@needs[0])
  end
  
  def to_s
    "#{self.class.to_s.downcase}(#{value})"
  end
  
  def be
    self
  end
  
  def known
    List.new(* self.class.recognized_messages.collect {|msg| Message.new(msg)})
  end
  
  def if
    Closure.new(Proc.new{|bool| bool.value ? self : Message.new("noop")},["¬"],"#{self.value} IF ?")
  end
  
  def know?
    Closure.new(
      Proc.new{|msg| Bool.new(self.class.recognized_messages.include?(msg.value))},
      ["do"],
      "#{self.value}.knows(?)")
  end
  
  # keep at end of class definition!
  @recognized_messages = [:know?, :if, :known, :be]
end
