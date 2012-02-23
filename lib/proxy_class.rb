#encoding: utf-8

module Duck
  class Proxy < Item
    
    @recognized_messages = [] # they should not inherit the Item messages
    
    
    def initialize(value)
      @value = value
      @needs = []
    end
    
    def details
      "↑(#{self.value.class}=#{self.value.object_id})↑"
    end
    
    def to_s
      "<PROXY>"
    end
    
    # DUCK METHODS
    
    duck_handle "^fork".intern do
      forked_interpreter = @value.deep_copy
      forked_interpreter.max_ticks = @value.max_ticks/2
      [message(:run), forked_interpreter]
    end
    
    
    duck_handle "^length".intern do
      @value.length
    end
    
    
    duck_handle "^quote".intern do
      Closure.new(["inc"], "<SCRIPT>.quote(?)") do |int|
        how_many = int.value
        new_string = how_many.times.inject("") {|memo,word| memo + " #{@value.script.next_word}"}
        Script.new(new_string.strip)
      end
    end
    
    
    duck_handle "^rescript".intern do
      Closure.new(["lowercase"], "<SCRIPT>.prepend(?)") do |other_script|
        old_script = @value.script.value
        if other_script.length + old_script.length < 32000
          @value.script = Script.new(other_script.value + " " + old_script)
          nil
        else
          Error.new("OVERSIZED SCRIPT")
        end
      end
    end
    
    
    duck_handle "^script".intern do
      @value.script.deep_copy
    end
  end
end