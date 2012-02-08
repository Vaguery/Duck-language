#encoding: utf-8
class Parser < Closure
  class << self; attr_reader :default_closure end
  
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
  
  
  @default_closure = Proc.new {}
  
  
  def initialize(needs = [], &closure)
    @closure = closure || Parser.default_closure
    @needs = needs
  end
  
  
  def step
    Parser.new(["lowercase"]) do |script|
      leader,token,remainder = script.value.partition(/\S+\s*/)
      result = [Parser.recognize(token.strip), Parser.new]
      result << Script.new(remainder) unless remainder == ""
      result
    end
  end
  
  
  def parse
    Parser.new(["lowercase"]) do |script|
      tokens = []
      remainder = script.value
      while remainder.length > 0
        leader,token,remainder = remainder.partition(/\S+\s*/)
        tokens << Parser.recognize(token.strip)
      end
      tokens
    end
  end
  
  
  def to_s
    @needs.empty? ? "π(-)" : "π(?)"
  end
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + [:step, :parse]
end