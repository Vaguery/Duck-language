#encoding:utf-8
class Bundle < Item
  attr_accessor :contents
  
  def initialize(*items)
    @contents = items.clone
    @needs = []
  end
  
  def shatter
    @contents.clone
  end
  
  def +
    Closure.new(Proc.new {|other_bundle| Bundle.new(*(other_bundle.contents.clone + @contents.clone))},
      ["count"],"#{self.to_s}+(?)")
  end
  
  def <<
    Closure.new(Proc.new {|item| Bundle.new(*(@contents.clone<<item))},
      ["be"],"#{self.to_s}<<?")
  end
  
  def unshift
    @contents.empty? ? self :
      [Bundle.new(*@contents[1..-1].clone),@contents[0].clone]
  end
  
  def pop
    if @contents.empty?
      self
    else
      item = @contents.pop.clone
      return [Bundle.new(*@contents.clone),item]
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
      Bundle.new(*@contents.clone) : Bundler.new(@contents.unshift(item).clone)}
    @needs = ["be"]
  end
  
  define_method( "(".intern ) {Bundle.new(*@contents.clone)}
  
  def to_s
    "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?) )"
  end
  
  # keep at end of class definition!
  @recognized_messages = (self.instance_methods - Object.instance_methods)
end