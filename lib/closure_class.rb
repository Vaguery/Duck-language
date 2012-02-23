#encoding: utf-8

def closure(needs=[], string = nil, &closure)
  Closure.new(needs, string, &closure)
end


module Duck
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
    
    
    def deep_copy
      Closure.new(@needs, @string_version, &@closure.clone)
    end
    
    
    def i_have_remaining_needs?
      @needs.length > 1
    end
    
    
    def throw_away_next_need
      @needs.delete_at(0)
    end
    
    
    def curry_the(object)
      begin
        @closure.clone.curry[object]
      rescue NoMethodError,TypeError => e
        Error.new("#{e.class.inspect}: #{e}")
      end
    end
    
    
    def act_on_the(arg)
      result = Closure.new(@needs)
      result.closure = curry_the(arg) # this is a Ruby syntax workaround I am sorry about
      return result
    end
    
    
    
    def grab(arg)
      my_message = @needs[0]
      unless can_use?(arg)
        self
      else
        if i_have_remaining_needs?
          throw_away_next_need
          if arg.personally_recognizes? my_message
            act_on_the arg # it's a binder providing an element
          else
            intermediate_result = Closure.new(@needs)
            intermediate_result.closure = curry_the(arg.produce_respondent(my_message))
            return [ arg, intermediate_result ].flatten
          end
        else
          if arg.personally_recognizes? my_message
            final_result = curry_the arg
            return final_result
          else # it's a binder providing an element
            combined_final_result = curry_the(arg.produce_respondent(my_message))
            return [ arg, combined_final_result ].flatten
          end
        end
      end
    end
  
  
    def to_s
      "λ(#{@string_version},#{@needs.inspect})"
    end
  
  
    # DUCK METHODS
  
  
    duck_handle :zap do
      nil
    end
  end
end