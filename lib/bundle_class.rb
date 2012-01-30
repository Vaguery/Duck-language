#encoding:utf-8
class Bundle < Item
  attr_accessor :contents
  
  def initialize(*items)
    @contents = items
    @needs = []
  end
  
  def shatter
    @contents.clone
  end
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    Bundle.new(*new_contents)
  end
  
  def +
    Closure.new(Proc.new {|other_bundle| Bundle.new(*(other_bundle.contents + @contents))},
      ["count"],"#{self.to_s}+(?)")
  end
  
  def << #push
    Closure.new(Proc.new {|item| Bundle.new(*(@contents.clone<<item.clone))},
      ["be"],"#{self.to_s} << ?")
  end
  
  def >> #unshift
    Closure.new(Proc.new {|item| Bundle.new(*(@contents.clone.unshift(item.clone)))},
      ["be"],"? >> #{self.to_s}")
  end
  
  def shift # release the first item
    @contents.empty? ? self :
      [Bundle.new(*@contents[1..-1].clone),@contents[0].clone]
  end
  
  def pop # release the last item
    if @contents.empty?
      self
    else
      item = @contents.pop
      return [Bundle.new(*@contents),item]
    end
  end
  
  def swap
    if @contents.length > 1
      new_contents = @contents.clone
      new_contents[-1],new_contents[-2] = @contents[-2].clone,@contents[-1].clone
      Bundle.new(*new_contents)
    else
      self
    end
  end
  
  def copy
    @contents.empty? ? self : Bundle.new(*(@contents.clone << @contents[-1].clone))
  end
  
  def reverse
    Bundle.new(*@contents.clone.reverse)
  end
  
  def empty
    Bundle.new
  end
  
  def []
    Closure.new(
      Proc.new do |idx| 
        index = idx.value.to_i
        how_many = self.contents.length
        which = how_many == 0 ? 0 : index % how_many
        self.contents[which].deep_copy unless how_many == 0
      end, ["inc"], "#{self.to_s}[?]")
  end
  
  def []=
    Closure.new(
      Proc.new do |idx,item|
        index = idx.value.to_i
        how_many = self.contents.length
        which = how_many == 0 ? 0 : index % how_many
        new_bundle = self.deep_copy
        new_bundle.contents[which] = item.deep_copy
        new_bundle
      end,
      ["inc","be"],
      "(item ? of #{self.inspect})"
    )
  end
  
  def give
    Closure.new(
      Proc.new do |item|
        new_contents = @contents.collect {|i| i.grab(item.deep_copy)}
        Bundle.new(*new_contents)
      end,
      ["be"],
      "give(#{self.inspect}, ?)"
    )
  end
  
  def map
    Closure.new(
      Proc.new do |item|
        new_contents = @contents.collect {|i| item.grab(i.deep_copy)}
        Bundle.new(*new_contents)
      end,
      ["be"],
      "#grab({self.inspect}, ?)"
    )
  end
  
  def count
    Int.new(@contents.length)
  end
  
  def to_s
    (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ")"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:count, :[], :empty, :reverse, :copy, :swap, :pop, :shift, :>>, :<<, :+, :shatter, :[]=, :give, :map]
end


class Bundler < Closure
  attr_accessor :closure, :contents
  
  def initialize(item_array=[])
    @contents = item_array
    @closure = Proc.new {|item| item.value == "(".intern ?
      Bundle.new(*@contents) : Bundler.new(@contents.unshift(item.deep_copy))}
    @needs = ["be"]
  end
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    Bundler.new(new_contents)
  end
  
  
  define_method( "(".intern ) {Bundle.new(*@contents.clone)}
  
  def to_s
    "λ( " + (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ", ?) )"
  end
  
  # keep at end of class definition!
  @recognized_messages = Closure.recognized_messages + ["(".intern]
end