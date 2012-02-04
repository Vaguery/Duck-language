#encoding: utf-8
require_relative './spec_helper'

describe "the :shift message for Lists" do
  it "should be something a List recognizes" do
    List.new.should respond_to(:shift)
  end
  
  it "should produce an Array of results, a List and an item" do
    breaker = List.new
    breaker.contents = [Int.new(8)]
    unshifted = breaker.shift
    unshifted.should be_a_kind_of(Array)
    unshifted[0].should be_a_kind_of(List)
    unshifted[1].should be_a_kind_of(Int)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 ) shift").run
    d.stack.inspect.should == "[(2), 1]"
  end
    
  it "should do nothing when received empty Lists (leaves the List intact)" do
    d = DuckInterpreter.new("( ) shift").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested Lists" do
    d = DuckInterpreter.new("( ( 1 ) ( 2 ( 3 4 ) ) ) shift").run
    d.stack.inspect.should == "[((2, (3, 4))), (1)]"
  end
end