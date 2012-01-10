require_relative './spec_helper'


describe "interpreter steps" do
  before(:each) do
    @ducky = DuckInterpreter.new("123 -912 foo +")
  end
  
  it "should move a recognized item onto the stack from the queue" do
    @ducky.step
    @ducky.stack[-1].value.should == 123
    @ducky.queue.length.should == 0
  end
  
  it "should be repeatable" do
    @ducky.step.step
  end
  
  it "should move a new item onto the stack when it's a literal" do
    @ducky.step.step
    @ducky.stack[0].value.should == 123
    @ducky.stack[1].value.should == -912
  end
  
  it "should send (unrecognized) messages to every stack item top-to-bottom" do
    pending
  end
  
  it "should not send messages to items after they're recognized" do
    pending
  end
end