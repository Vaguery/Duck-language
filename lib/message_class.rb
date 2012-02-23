module Duck
  
  def message(string)
    Message.new(string)
  end

  class Message < Closure
    def initialize(string)
      @closure = Proc.new {|receiver| receiver.__send__(string) }
      @needs = [string]
      @value = string.intern
    end
    
    
    def deep_copy
      Message.new(@value)
    end
    
    
    def to_s
      ":#{@value}"
    end
  
    def grab(object)
      if can_use?(object)
        if object.personally_recognizes?(@value)
          @closure.curry[object]
        else
          results = [object, @closure.curry[object.produce_respondent(@value)]].flatten
          results
        end
      else
        self
      end
    end
  
    # DUCK METHODS
  
  
    duck_handle :do do
      self
    end
  
  
    duck_handle :eql do
      Closure.new(["do"],"? == #{self.value}") {|arg1| Bool.new(arg1.value == self.value)}
    end
  end
end