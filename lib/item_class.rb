#encoding:utf-8
module Duck
  class Item
    class << self; attr_accessor :recognized_messages end
    @recognized_messages = []
  
    def self.inherited(subclass)
      subclass.recognized_messages = self.recognized_messages.clone
    end
  
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

    def inspect
      self.to_s
    end
    
    def recognize_message?(string)
      msg = string.intern
      self.class.recognized_messages.include?(msg) ||
        self.singleton_methods.include?(msg)
    end
    
    def messages
      self.class.recognized_messages | self.singleton_methods
    end
    
    def personally_recognizes?(string)
      recognize_message?(string)
    end
    
    def can_use?(object)
      !@needs.empty? && object.recognize_message?(@needs[0])
    end
    
    def to_s
      "#{self.class.to_s.downcase}(#{value})"
    end
    
    def self.duck_handle(name, &block)
      define_method(name, &block)
      @recognized_messages << name
    end
    
    def give_ticks
      0
    end
    
    # DUCK METHODS
    
    
    duck_handle :above do
      Closure.new(["be"], "#{self.value}.above(?)") do |arg|
        [arg,self]
      end
    end
    
    
    duck_handle :be do
      self
    end
    
    
    duck_handle :below do
      Closure.new(["be"], "#{self.value}.below(?)") do |arg|
        [self,arg]
      end
    end
    
    
    duck_handle "known[]".intern do
      Closure.new(["inc"], "#{self.inspect}.known[?]") do |index|
        which_one = index.value.to_i
        how_many = self.messages.length
        Message.new(messages[which_one % how_many])
      end
    end
    
    
    duck_handle :if do
      Closure.new(["¬"],"#{self.value} IF ?") {|bool| bool.value ? self : nil}
    end
    
    
    duck_handle :keep do
      Binder.new [self]
    end
    
    
    duck_handle :know? do
      Closure.new(["do"],"#{self.value}.knows(?)") do |msg|
        Bool.new(self.class.recognized_messages.include?(msg.value))
      end
    end
    
    
    duck_handle :size do
      [self, Int.new(1)]
    end
    
    
    duck_handle :wrap do
      List.new( [self] )
    end
    
  end
end