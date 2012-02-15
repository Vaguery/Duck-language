#encoding:utf-8
require_relative '../spec_helper'

describe "List objects" do
  describe "initialization" do
    it "should have a Duck shortcut" do
      list.should be_a_kind_of(List)
      list([int(3), bool(F)]).inspect.should == "(3, F)"
      list( [list( [ int(3), decimal(9.9)]),int(8)]).inspect.should == "((3, 9.9), 8)"
    end
  end
  
  describe "contents" do
    it "should have an Array of contents" do
      b = list([int(1),int(2)])
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
    
    it "should accept an unsplatted array" do
      b = list([int(1),int(2)])
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
  
  describe "working as a variable binding" do
    it "should put itself onto the stack correctly" do
      b = list([int(1),int(2)])
      d = interpreter(script:"x x x", binder:{x:b})
      d.run.contents.inspect.should == "[(1, 2), (1, 2), :x=(1, 2), (1, 2)]"
    end
  end
  
  
  describe "needs" do
    it "should have no @needs" do
      List.new.needs.should == []
    end
  end
end


describe "visualization" do
  it "should list the contents" do
    list([int(1),int(2)]).to_s.should == "(1, 2)"
    List.new.to_s.should == "()"
    list([list([list([int(1)]),int(2)]),int(2)]).to_s.should == "(((1), 2), 2)"
  end
end
