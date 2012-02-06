#encoding: utf-8
class Script < Item
  attr_accessor :value
  
  def self.recognize(string)
    case string
    when /^\)$/
      Connector.new()
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
  
  ######################
  #
  # PUBLIC DUCK METHODS
  #
  ######################
  
  def lowercase
    Script.new(@value.downcase)
  end
  
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:lowercase]
end