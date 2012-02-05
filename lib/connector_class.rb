#encoding: utf-8

class Connector < Closure
  attr_accessor :closure, :contents
  
  def initialize(item_array=[])
    @contents = item_array
    @closure = Proc.new {|item| item.value == "(".intern ?
      List.new(@contents) : Connector.new(@contents.unshift(item.deep_copy))}
    @needs = ["be"]
  end
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    Connector.new(new_contents)
  end
  
  define_method( "(".intern ) {List.new(@contents.clone)}
  
  def to_s
    "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?) )"
  end
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + ["(".intern]
end