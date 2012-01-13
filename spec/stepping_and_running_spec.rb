require_relative './spec_helper'

describe "interpreter steps" do
  
  describe "literals" do
  end
  
  describe "messages" do
    it "should check each item in the stack to see if it recognizes the message" do
      d = DuckInterpreter.new("1 2 3 foo")
      d.step.step.step
      d.stack[-1].should_receive(:respond_to?).with("foo").and_return(false)
      d.step
    end
    
    it "should delete the topmost stack item that responds" do
      d = DuckInterpreter.new("1 2 3 foo")
      d.step.step.step
      d.stack[1].stub(:foo).and_return(["I am 2.foo"])
      d.step
      d.stack.length.should == 3
      d.stack[-1].should == "I am 2.foo"
    end
        
    it "should push a MessageItem instance if nothing recognizes the message" do
      DuckInterpreter.new("foo").step.stack[-1].value.should == "foo"
    end
  end
end


describe "running a simple script" do
  it "should run until the script is consumed" do
    DuckInterpreter.new("1 2 3 4").run.script.should == ""
  end
  
  it "should empty the queue" do
    DuckInterpreter.new("1 2 3 4").run.queue.length.should == 0
  end
  
  it "should leave items on the stack in its final state" do
    DuckInterpreter.new("1 2 3 4").run.stack.length.should == 4
  end
end

describe "staged items" do
  before(:each) do
    @closet = DuckInterpreter.new("1 + 2")
  end
  
  it "should check the staged item's needs before pushing it" do
    pending
  end
  
  it "should check whether the staged item fills stack items' needs" do
    pending
  end
end




describe "running a growing script that makes new tokens" do
  it "should clear the script" do
    DuckInterpreter.new("1 dup dup").run.script.should == ""
  end
  
  it "should clear the queue" do
    DuckInterpreter.new("1 dup dup").run.queue.length.should == 0
  end
  
  it "should have the stack items in the right order" do
    DuckInterpreter.new("1 dup 2 dup").run.stack.collect{|i| i.value}.should == [1,1,2,2]
  end
end