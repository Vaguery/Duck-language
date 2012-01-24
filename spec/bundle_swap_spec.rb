#encoding: utf-8
require_relative './spec_helper'

describe "the :swap message for Bundles" do
  it "should be something a Bundle recognizes" do
    Bundle.new.should respond_to(:swap)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 3 4 ) swap").run
    d.stack.inspect.should == "[(1, 2, 4, 3)]"
  end
  
  it "should do nothing to Bundles with one element" do
    d = DuckInterpreter.new("( 3 ) swap").run
    d.stack.inspect.should == "[(3)]"
  end
  
  it "should work with empty Bundles" do
    d = DuckInterpreter.new("( ) swap").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested bundles" do
    d = DuckInterpreter.new("( ( 1 ) 2 ( 3 ( 4 ) ) ) swap").run
    d.stack.inspect.should == "[((1), (3, (4)), 2)]"
  end
end