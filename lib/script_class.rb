#encoding: utf-8

def script(value="")
  Script.new(value)
end

module Duck
  class Script < Item
    attr_accessor :value
  
    def self.recognize(string)
      case string
      when /^\)$/
        Pipe.new()
      when /^[-+]?[0-9]+$/
        Int.new(string.to_i)
      when /^[-+]?[0-9]+\.[0-9]*$/
        Decimal.new(string.to_f)
      when 'true','T'
        Bool.new(true)
      when 'false','F'
        Bool.new(false)
      else
        Message.new(string) unless string.strip==""
      end
    end
  
    def init(value="")
      @value = value
    end
  
    def next_word
      leader,word,@value = @value.partition(/\S+\s*/)
      word.strip
    end
  
    def next_token
      Script.recognize(next_word)
    end
  
    def length
      @value.length
    end
  
    def to_s
      "«#{self.value}»"
    end
  
    # DUCK METHODS
  
    duck_handle :lowercase do
      Script.new(@value.downcase)
    end
  end
end