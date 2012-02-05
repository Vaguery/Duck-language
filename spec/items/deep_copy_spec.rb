require_relative '../spec_helper'

describe "Stack Item deep copy method" do
  it "should work for Ints" do
    i = Int.new(9)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Bools" do
    i = Bool.new(false)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Decimals" do
    i = Decimal.new(8.12)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Closures" do
    i = Closure.new(Proc.new{|a| a.value + self.value},["be"],"foo")
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should clone all the contents items of a List" do
    i = List.new(Int.new(8), Int.new(9))
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
  it "should work recursively to get nested Lists" do
    i = List.new(Int.new(8), Int.new(9), List.new(Int.new(8), Int.new(9)))
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
  it "should work for Connectors" do
    i = Connector.new([Int.new(8), Int.new(9)])
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
end