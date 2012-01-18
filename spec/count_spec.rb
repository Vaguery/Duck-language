require_relative './spec_helper'

describe "count message" do
  it "should be recognized by Bundles" do
    Bundle.new.should respond_to(:count)
  end
  
  it "should produce an Int containing the Bundle's [root] length" do
    d = DuckInterpreter.new("count")
    d.stack.push Bundle.new(Bundle.new(Int.new(1),Int.new(2)))
    d.run
    d.stack.inspect.should == "[1]"
  end
end