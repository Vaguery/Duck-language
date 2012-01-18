require_relative './spec_helper'

describe "shatter message" do
  it "should be recognized by Bundle items" do
    Bundle.new.should respond_to(:shatter)
  end
  
  it "should queue the item's contents" do
    s = Bundle.new(Int.new(1),Bool.new(false))
    d = DuckInterpreter.new("shatter")
    d.stack.push s # as of this writing, no way to parse a Bundle...
    d.run
    d.stack.inspect.should == "[1, F]"
  end
  
  it "should work for an empty Bundle" do
    s = Bundle.new
    d = DuckInterpreter.new("shatter")
    d.stack.push s # as of this writing, no way to parse a Bundle...
    d.run
    d.stack.length.should == 0
  end
end