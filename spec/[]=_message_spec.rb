require_relative './spec_helper'

describe "the :[]= message for Bundles" do
  before(:each) do
    @msg = "[]=".intern
  end
  
  it "should be something Bundles recognize" do
    Bundle.new.should respond_to(@msg)
  end
  
  it "should produce a closure, looking for a number that responds to ++ AND some item" do
    wanting = Bundle.new.send(@msg)
    wanting.should be_a_kind_of(Closure)
    wanting.needs.should == ["inc","be"]
  end
  
  it "should replace the nth element of the Bundle with the new item" do
    d = DuckInterpreter.new("( 1 2 3 4 ) 9 1 []=").run
    d.stack.inspect.should == "[(1, 9, 3, 4)]"
  end
  
  it "should work with negative integers" do
    d = DuckInterpreter.new("( 1 2 3 4 ) 9 -2 []=").run
    d.stack.inspect.should == "[(1, 2, 9, 4)]"
  end
  
  it "should work with large positive integers" do
    d = DuckInterpreter.new("( 1 2 3 4 ) 9 12 []=").run
    d.stack.inspect.should == "[(9, 2, 3, 4)]"
  end
  
  it "should work with an empty Bundle" do
    d = DuckInterpreter.new("( ) 9 12 []=").run
    d.stack.inspect.should == "[(9)]"
  end
end