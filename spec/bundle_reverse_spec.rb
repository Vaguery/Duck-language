#encoding: utf-8
require_relative './spec_helper'

describe "the :reverse message for Bundles" do
  it "should be something a Bundle recognizes" do
    Bundle.new.should respond_to(:reverse)
  end
  
  it "should produce a closure looking for another Bundle" do
    asswards = Bundle.new.reverse
    asswards.should be_a_kind_of(Bundle)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 3 4 ) reverse").run
    d.stack.inspect.should == "[(4, 3, 2, 1)]"
  end
  
  it "should work with empty Bundles" do
    d = DuckInterpreter.new("( ) reverse").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested bundles" do
    d = DuckInterpreter.new("( ( 1 ) 2 ( 3 ( 4 ) ) ) reverse").run
    d.stack.inspect.should == "[((3, (4)), 2, (1))]"
  end
end