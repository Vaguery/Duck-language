require_relative './spec_helper'

describe "the :quote message" do
  it "should be recognized by the interpreter" do
    DuckInterpreter.new.should respond_to(:quote)
  end
  
  it "should fail silently if the script is empty" do
    d = DuckInterpreter.new("1 2 quote")
    d.run
    d.stack.inspect.should == "[1, 2]"
  end
  
  it "should push the next queued item directly onto the stack (without staging)" do
    d = DuckInterpreter.new("1 + quote 3 4")
    d.run
    d.stack.inspect.should == "[3, 5]"
  end
end