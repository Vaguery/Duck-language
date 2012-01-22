#encoding:utf-8
class Bundle < Item
  attr_accessor :contents
  
  def initialize(*items)
    @contents = items
    @needs = []
  end
  
  def shatter
    @contents
  end
  
  def +
    Closure.new(Proc.new {|other_bundle| Bundle.new(*(other_bundle.contents + @contents))},
      ["count"],"#{self.to_s}+(?)")
  end
  
  def <<
    Closure.new(Proc.new {|item| Bundle.new(*(@contents<<item))},
      ["be"],"#{self.to_s}<<?")
  end
  
  def unshift
    @contents.empty? ? self :
      [Bundle.new(*@contents[1..-1]),@contents[0]]
  end
  
  def pop
    @contents.empty? ? self :
      begin
        item = @contents.pop
        return [Bundle.new(*@contents),item]
      end
      
  end
  
  def count
    Int.new(@contents.length)
  end
  
  def to_s
    (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ")"
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end


class Bundler < Closure
  attr_accessor :closure, :contents
  
  def initialize(item_array=[])
    @contents = item_array
    @closure = Proc.new {|item| item.value == "(".intern ?
      Bundle.new(*@contents) : Bundler.new(@contents.unshift(item))}
    @needs = ["be"]
  end
  
  define_method( "(".intern ) {Bundle.new(*@contents)}
  
  def to_s
    "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?) )"
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end