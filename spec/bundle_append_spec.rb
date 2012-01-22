#encoding: utf-8
require_relative './spec_helper'

describe "the :<< message for Bundles" do
  it "should be something a Bundle recognizes" do
    Bundle.new.should respond_to(:<<)
  end
  
  it "should produce a closure looking for another Bundle" do
    grabby = Bundle.new.<<
    grabby.should be_a_kind_of(Closure)
    grabby.needs.should == ["be"]
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 ) ( 3 4 ) <<").run
    d.stack.inspect.should == "[(3, 4, (1, 2))]"
  end
  
  it "the Closure should be descriptive when printed" do
    d = DuckInterpreter.new("( 1 2 3 ) <<").run
    d.stack.inspect.should == "[λ((1, 2, 3)<<?,[\"be\"])]"
  end
  
  it "should work with empty Bundles" do
    d = DuckInterpreter.new("( ) ( ) <<").run
    d.stack.inspect.should == "[(())]"
  end
  
  it "should work with nested bundles" do
    d = DuckInterpreter.new("( ( 1 ) 2 ) ( 3 ( 4 ) ) <<").run
    d.stack.inspect.should == "[(3, (4), ((1), 2))]"
  end
end