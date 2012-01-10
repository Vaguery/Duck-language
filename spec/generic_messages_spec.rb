require_relative './spec_helper'

describe "generic StackItem messages" do
  
  describe ":disappear" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 2 disappear").step.step
    end
    
    it "should be recognized" do
      @ducky.stack[-1].should respond_to("disappear")
    end
    
    it "should delete the responding item" do
      @ducky.step
      @ducky.stack.length.should == 1
      @ducky.queue.length.should == 0
    end
  end
  
  describe "dup" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 2 dup").step.step
    end
    
    it "should be recognized" do
      @ducky.stack[-1].should respond_to("dup")
    end
    
    it "should produce two new copies of the responding item" do
      @ducky.step
      @ducky.stack[-1].value.should == 2
      @ducky.queue[0].value.should == 2
    end
    
  end
end