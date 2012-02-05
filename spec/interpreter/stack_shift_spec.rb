#encoding: utf-8
require_relative '../spec_helper'

describe "the :shift message for the Interpreter" do
  it "should be something the Interpreter recognizes" do
    DuckInterpreter.new.should respond_to(:shift)
  end
  
  it "should remove the bottom item from the stack, and unshift it onto the queue" do
    d = DuckInterpreter.new("1 2 3 4").run
    d.shift
    d.stack.length.should == 3
    d.queue[0].value.should == 1
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("1 2 3 4 shift").run
    d.stack.inspect.should == "[2, 3, 4, 1]"
  end
    
  it "should do nothing when the stack is empty" do
    d = DuckInterpreter.new("shift").run
    d.stack.inspect.should == "[]"
  end
end