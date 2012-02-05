#encoding: utf-8
require_relative './spec_helper'

describe "the :push message for Lists" do
  it "should be something a List recognizes" do
    List.new.should respond_to(:push)
  end
  
  it "should produce a closure looking for another List" do
    grabby = List.new.push
    grabby.should be_a_kind_of(Closure)
    grabby.needs.should == ["be"]
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 ) ( 3 4 ) push").run
    d.stack.inspect.should == "[(3, 4, (1, 2))]"
  end
  
  it "the Closure should be descriptive when printed" do
    d = DuckInterpreter.new("( 1 2 3 ) push").run
    d.stack.inspect.should == "[λ((1, 2, 3).push(?),[\"be\"])]"
  end
  
  it "should work with empty Lists" do
    d = DuckInterpreter.new("( ) ( ) push").run
    d.stack.inspect.should == "[(())]"
  end
  
  it "should work with nested Lists" do
    d = DuckInterpreter.new("( ( 1 ) 2 ) ( 3 ( 4 ) ) push").run
    d.stack.inspect.should == "[(3, (4), ((1), 2))]"
  end
end