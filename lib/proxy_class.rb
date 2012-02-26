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
    
    
    duck_handle "^clear".intern do
      @value.contents << List.new(@value.buffer)
      @value.buffer = []
      nil
    end
    
    
    duck_handle "^flush".intern do
      @value.halted = true
      @value.contents << List.new(@value.buffer)
      @value.buffer = []
      @value.contents << @value.script.deep_copy
      @value.script = Script.new
      nil
    end
    
    
    duck_handle "^fork".intern do
      forked_interpreter = @value.deep_copy
      forked_interpreter.max_ticks = @value.max_ticks/2
      [message(:run), forked_interpreter]
    end
    
    
    
    duck_handle "^greedy=".intern do
      Closure.new(["¬"], "<INTERPRETER>.greedy=(?)") do |bool|
        @value.greedy_flag = bool.value
        nil
      end
    end
    
    
    duck_handle "^length".intern do
      @value.length
    end
    
    
    duck_handle "^quote".intern do
      Closure.new(["inc"], "<SCRIPT>.quote(?)") do |int|
        how_many = int.value
        new_string = how_many.times.inject("") do |memo,word|
          break memo if @value.script.value.strip.empty?
          memo + " #{@value.script.next_word}"
        end
        Script.new(new_string.strip)
      end
    end
    
    
    duck_handle "^rescript".intern do
      Closure.new(["lowercase"], "<SCRIPT>.prepend(?)") do |other_script|
        old_script = @value.script.value
        other_script = other_script.value
        if other_script.length + old_script.length < 20000
          @value.script = Script.new(other_script + " " + old_script)
          nil
        else
          Error.new("OVERSIZED SCRIPT")
        end
      end
    end
    
    
    duck_handle "^script".intern do
      @value.script.deep_copy
    end
    
    
    duck_handle "^ticks".intern do
      Int.new( @value.ticks )
    end
    
  end
end