require_relative './spec_helper'

describe "empty message" do
  it "should be recognized by Interpreter" do
    DuckInterpreter.new.should respond_to(:empty)
  end
  
  it "should empty the stack entirely" do
    d = DuckInterpreter.new("1 2 3 4 5 6 ( 7 8 )").run
    d.stack.length.should  == 7
    d.empty
    d.stack.length.should == 0
  end
end