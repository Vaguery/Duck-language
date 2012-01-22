#encoding: utf-8
require_relative './spec_helper'

describe "the :shift message for Bundles" do
  it "should be something a Bundle recognizes" do
    Bundle.new.should respond_to(:shift)
  end
  
  it "should produce an Array of results, a Bundle and an item" do
    breaker = Bundle.new
    breaker.contents = [Int.new(8)]
    unshifted = breaker.shift
    unshifted.should be_a_kind_of(Array)
    unshifted[0].should be_a_kind_of(Bundle)
    unshifted[1].should be_a_kind_of(Int)
  end
  
  it "should produce the expected output" do
    d = DuckInterpreter.new("( 1 2 ) shift").run
    d.stack.inspect.should == "[(2), 1]"
  end
    
  it "should do nothing when received empty Bundles (leaves the bundle intact)" do
    d = DuckInterpreter.new("( ) shift").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work with nested bundles" do
    d = DuckInterpreter.new("( ( 1 ) ( 2 ( 3 4 ) ) ) shift").run
    d.stack.inspect.should == "[((2, (3, 4))), (1)]"
  end
end