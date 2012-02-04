#encoding: utf-8
require_relative './spec_helper'

describe "the :pop message for Lists" do
  it "should be something a List recognizes" do
    List.new.should respond_to(:pop)
  end
  
  it "should produce an Array of results, a List and an item" do
    breaker = List.new
    breaker.contents = [Int.new(8)]
    unshifted = breaker.pop
    unshifted.should be_a_kind_of(Array)
    unshifted[0].should be_a_kind_of(List)
    unshifted[1].should be_a_kind_of(Int)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 ) pop").run
    d.stack.inspect.should == "[(1), 2]"
  end
    
  it "should do nothing when received empty Lists (leaves the List intact)" do
    d = DuckInterpreter.new("( ) pop").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested Lists" do
    d = DuckInterpreter.new("( ( 1 ) ( 2 ( 3 4 ) ) ) pop pop").run
    d.stack.inspect.should == "[((1)), (2), (3, 4)]"
  end
end