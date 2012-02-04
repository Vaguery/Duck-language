#encoding: utf-8
require_relative './spec_helper'

describe "the :swap message for Lists" do
  it "should be something a List recognizes" do
    List.new.should respond_to(:swap)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 3 4 ) swap").run
    d.stack.inspect.should == "[(1, 2, 4, 3)]"
  end
  
  it "should do nothing to Lists with one element" do
    d = DuckInterpreter.new("( 3 ) swap").run
    d.stack.inspect.should == "[(3)]"
  end
  
  it "should work with empty Lists" do
    d = DuckInterpreter.new("( ) swap").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested Lists" do
    d = DuckInterpreter.new("( ( 1 ) 2 ( 3 ( 4 ) ) ) swap").run
    d.stack.inspect.should == "[((1), (3, (4)), 2)]"
  end
end