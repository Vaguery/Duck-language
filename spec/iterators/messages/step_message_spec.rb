#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "step" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :step
    end
    
    it "should return itself if the index is outside the range, while resetting the index to the close end" do
      askew = Iterator.new(start:0, end:3, index:9)
      askew.step.should == askew
      askew.index.should == 3
      
      askew = Iterator.new(start:0, end:3, index:-9)
      askew.step.should == askew
      askew.index.should == 0
    end
    
    it "should add the inc to the index and return itself FLAT with its contents otherwise" do
      four_threes = Iterator.new(start:0, end:3, contents:[int(3)])
      four_threes.step.inspect.should == "[(0..1..3)=>[3], 3]"
      four_threes.step.inspect.should == "[(0..2..3)=>[3], 3]"
      four_threes.step.inspect.should == "[(0..3..3)=>[3], 3]"
      four_threes.step.inspect.should == "(0..3..3)=>[3]"
      
    end
    
    it "should detect when the sign of the inc and the order of extremes needs changing" do
      down = Iterator.new(start:10,end:3, index:7, contents:[bool(F)])
      down.step.inspect.should == "[(10..6..3)=>[F], F]"
      
      down = Iterator.new(start:10,end:3, inc:-2, contents:[bool(F)])
      down.step.inspect.should == "[(10..8..3)=>[F], F]"
      
    end
    
    it "should return a an empty Array item if nothing is bound" do
      four_threes = Iterator.new(start:0, end:3)
      four_threes.step.inspect.should == "[(0..1..3)=>[]]"
      four_threes.step.inspect.should == "[(0..2..3)=>[]]"
      four_threes.step.inspect.should == "[(0..3..3)=>[]]"
      four_threes.step.inspect.should == "(0..3..3)=>[]"
      four_threes.step.inspect.should == "(0..3..3)=>[]"
    end
  end
end
