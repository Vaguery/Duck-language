#encoding: utf-8
class Interpreter < Assembler
  attr_accessor :script
  
  def initialize(script = "", contents = [], buffer = [])
    @script = Script.new(script)
    @contents = contents
    @buffer = buffer
    @needs = []
  end
  
  def to_s
    rep = (@contents.inject("[") {|s,i| s+i.to_s+", "}).chomp(", ")
    rep += @contents.empty? ? "::" : " ::"
    rep += (@buffer.inject(" ") {|s,i| s+i.to_s+", "}).chomp(", ") unless @buffer.empty?
    rep += " :: "
    rep += @script.to_s
    rep += "]"
  end
  
  def next_token
    push(@script.next_token)
  end
  
  def run
    while @script.length > 0 || @buffer.length > 0
      next_token if @buffer.empty?
      process_buffer unless @buffer.empty?
    end
  end
  
end