#encoding: utf-8
class Parser < Closure
  
  def self.recognize(string)
    case string
    when /^\)$/
      Bundler.new()
    when /^[-+]?[0-9]+$/
      Int.new(string.to_i)
    when /^[-+]?[0-9]+\.[0-9]*$/
      Decimal.new(string.to_f)
    when 'true','T'
      Bool.new(true)
    when 'false','F'
      Bool.new(false)
    else
      Message.new(string)
    end
  end
  
  
  def initialize
    @closure = Proc.new do |script|
        leader,token,remainder = script.value.partition(/\S+\s*/)
        [Parser.recognize(token.strip),Script.new(remainder)]
      end
    @needs = ["lowercase"]
  end  
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + []
end