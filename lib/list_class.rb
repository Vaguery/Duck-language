#encoding:utf-8
require 'timeout'


class List < Item
  attr_accessor :contents
  
  def initialize(contents=[])
    @contents = contents
    @needs = []
  end
  
  def shatter
    @contents.clone
  end
  
  def deep_copy
    new_contents = @contents.collect {|i| i.deep_copy}
    self.class.new(new_contents)
  end
  
  def +
    Closure.new(["count"],"#{self.to_s}+(?)") {|other_list| List.new(other_list.contents + @contents)}
  end
  
  def push
    Closure.new(["be"],"#{self.to_s}.push(?)") {|item| List.new(@contents.clone << item.deep_copy)}
  end
  
  def unshift 
    Closure.new(["be"],"#{self.to_s}.unshift(?)") do |item|
      self.class.new(@contents.clone.unshift(item.deep_copy))
    end
  end
  
  def shift # release the first item
    @contents.empty? ? self :
      [self.class.new(@contents[1..-1].clone),@contents[0].clone]
  end
  
  def pop # release the last item
    if @contents.empty?
      self
    else
      item = @contents.pop
      return [self.class.new(@contents),item]
    end
  end
  
  def swap
    if @contents.length > 1
      new_contents = @contents.clone
      new_contents[-1],new_contents[-2] = @contents[-2].clone,@contents[-1].clone
      self.class.new(new_contents)
    else
      self
    end
  end
  
  def copy
    @contents.empty? ? self : self.class.new(@contents.clone << @contents[-1].clone)
  end
  
  def reverse
    self.class.new(@contents.clone.reverse)
  end
  
  def empty
    self.class.new
  end
  
  
  def []
    Closure.new(["inc"], "#{self.to_s}[?]") do |idx| 
      index = idx.value.to_i
      how_many = self.contents.length
      which = how_many == 0 ? 0 : index % how_many
      self.contents[which].deep_copy unless how_many == 0
    end
  end
  
  
  def []=
    Closure.new(['inc', 'be'],"") do |index, new_item|
      new_list = self.deep_copy
      idx = index.value.to_i
      which = (@contents.length == 0) ? 0 : (idx % @contents.length)
      new_list.contents[which] = new_item.deep_copy
      new_list
    end 
  end
  
  
  def give
    Closure.new(["be"],"give(#{self.inspect}, ?)") do |item|
      results = @contents.collect {|i| i.grab(item.deep_copy)}.flatten
      new_contents = results.reject {|i| i.nil?}
      List.new(new_contents)
    end
  end
  
  
  def map
    Closure.new(["be"],"map(#{self.inspect}, ?)") do |item|
      results = @contents.collect {|i| item.deep_copy.grab(i.deep_copy)}.flatten
      new_contents = results.reject {|i| i.nil?}
      size = new_contents.inject("") {|rep,i| rep+(i.to_s)}.length
      size < @@result_size_limit ? List.new(new_contents) : Error.new("OVERSIZE")
    end
  end
  
  
  def useful
    Closure.new(["be"],"#useful({self.inspect}, ?)") do |item|
      results = @contents.group_by {|element| item.can_use?(element) ? "useful" : "unuseful"}
      [self.class.new(results["useful"]||[]), self.class.new(results["unuseful"]||[])]
    end
  end
  
  
  def users
    Closure.new(["be"],"#users({self.inspect}, ?)") do |item|
      results = @contents.group_by {|element| element.can_use?(item) ? "users" : "nonusers"}
      [List.new(results["users"]||[]), List.new(results["nonusers"]||[])]
    end
  end
  
  
  def ∪
    Closure.new(["count"],"#{self.inspect} ∪ ?") do |other_list|
      aggregated = other_list.contents + @contents
      self.class.new(aggregated.uniq {|element| element.inspect})
    end
  end
  
  
  def ∩
    Closure.new(["count"],"#{self.inspect} ∩ ?") do |other_list|
      overlappers = other_list.contents.collect {|item| item.inspect}
      self.class.new(@contents.select {|element| overlappers.include? element.inspect})
    end
  end
  
  
  def rotate
    self.class.new(@contents.rotate(1))
  end
  
  
  def flatten
    new_contents = @contents.inject([]) do |arr,item|
      item.kind_of?(List) ?
      arr + item.contents :
      arr << item
    end
    self.class.new(new_contents)
  end
  
  def snap
    Closure.new(["inc"],"snap#{self.inspect} at ?") do |location|
      if @contents.length > 0
        where = location.value.to_i % @contents.length
        [self.class.new(@contents[0...where]),self.class.new(@contents[where..-1])]
      else
        self
      end
    end
  end
  
  def rewrap_by
    Closure.new(["inc"], "rewrap#{self.inspect} by ?") do |size|
      slice_size = size.value.to_i
      slice_size = @contents.length if slice_size < 1
      @contents.empty? ?
        self :
        @contents.each_slice(slice_size).collect {|chunk| self.class.new(chunk)}
    end
  end
  
  
  def count
    Int.new(@contents.length)
  end
  
  def to_s
    (@contents.inject("(") {|s,i| s+i.to_s+", "}).chomp(", ") + ")"
  end
  
  # keep at end of class definition!
  @recognized_messages = Item.recognized_messages + [:count, :[], :empty, :reverse, :copy, :swap, :pop, :shift, :unshift, :push, :+, :shatter, :[]=, :give, :map, :useful, :users, :∪, :∩, :flatten, :snap, :rewrap_by, :rotate]
end
