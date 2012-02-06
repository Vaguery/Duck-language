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
  
end