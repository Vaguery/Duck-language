require_relative './spec_helper'

describe "shatter message" do
  before(:each) do
    @d = DuckInterpreter.new("shatter")
  end
  
  it "should be recognized by Bundle items" do
    Bundle.new.should respond_to(:shatter)
  end
  
  it "should queue the item's contents" do
    s = Bundle.new(Int.new(1),Bool.new(false))
    @d.stack.push s # as of this writing, no way to parse a Bundle...
    @d.run
    @d.stack.inspect.should == "[1, F]"
  end
  
  it "should work for an empty Bundle" do
    s = Bundle.new
    @d.stack.push s # as of this writing, no way to parse a Bundle...
    @d.run
    @d.stack.length.should == 0
  end
  
  it "should leave interior Bundles intact" do
    s2 = Bundle.new(Bundle.new(Int.new(1),Bool.new(false)),Int.new(2))
    @d.stack.push s2
    @d.run
    @d.stack.inspect.should == "[(1, F), 2]"
  end
  
  it "should work on script-produced bundles" do
    @d.reset("( 1 2 3 4 5 ( 6 7 8 ) ) 9 shatter")
    @d.run
    @d.stack.inspect.should == "[9, 1, 2, 3, 4, 5, (6, 7, 8)]"
  end
end