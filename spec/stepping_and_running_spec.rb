require_relative './spec_helper'

describe "interpreter steps" do
  
  describe "literals" do
    before(:each) do
      @ducky = DuckInterpreter.new("123 -912")
    end
    
    it "should be repeatable" do
      lambda {@ducky.step.step}.should_not raise_error
    end
  
    it "should move a new item onto the stack when it's a literal" do
      @ducky.step.step
      @ducky.stack[0].value.should == 123
      @ducky.stack[1].value.should == -912
    end
    
    it "should recognize IntegerItems" do
      DuckInterpreter.new("123 -912").step.stack[-1].value.should == 123
    end
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