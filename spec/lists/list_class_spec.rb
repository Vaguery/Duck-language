#encoding:utf-8
require_relative '../spec_helper'

describe "List objects" do
  describe "contents" do
    it "should have an Array of contents" do
      b = List.new([Int.new(1),Int.new(2)])
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
    
    it "should accept a splatted array" do
      b = List.new([Int.new(1),Int.new(2)])
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
  
  describe "working as a variable binding" do
    it "should put itself onto the stack correctly" do
      b = List.new([Int.new(1),Int.new(2)])
      d = DuckInterpreter.new("x x x", {"x" => b})
      d.run.stack.inspect.should == "[(1, 2), (1, 2), (1, 2)]"
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
    List.new([Int.new(1),Int.new(2)]).to_s.should == "(1, 2)"
    List.new.to_s.should == "()"
    List.new([List.new([List.new([Int.new(1)]),Int.new(2)]),Int.new(2)]).to_s.should == "(((1), 2), 2)"
  end
end
