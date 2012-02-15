require_relative '../spec_helper'

describe "personally_recognizes?(message)" do
  it "should default (in most classes) to recognize_message?(message)" do
    Item.new.personally_recognizes?("foo").should == Item.new.recognize_message?("foo")
  end
end

describe "Stack Item deep copy method" do
  it "should work for Ints" do
    i = int(9)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Bools" do
    i = bool(F)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Decimals" do
    i = decimal(8.12)
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should work for Closures" do
    i = closure(["be"],"foo") {|a| a.value + self.value}
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.value.should == j.value
  end
  
  it "should clone all the contents items of a List" do
    i = list([int(8), int(9)])
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
  it "should work recursively to get nested Lists" do
    i = list([int(8), int(9), list([int(8), int(9)])])
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
  it "should work for Pipes" do
    i = Pipe.new([int(8), int(9)])
    j = i.deep_copy
    i.object_id.should_not == j.object_id
    i.contents.each_with_index do |item,idx|
      item.object_id.should_not == j.contents[idx].object_id
    end
  end
  
end