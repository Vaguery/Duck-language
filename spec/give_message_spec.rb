#encoding: utf-8
require_relative './spec_helper'

describe "the :give message for Bundles" do
  it "should be something Bundles recognize" do
    Bundle.new.should respond_to(:give)
  end
  
  it "should produce a closure, looking for any item" do
    Bundle.new.give.should be_a_kind_of(Closure)
    Bundle.new.give.needs.should == ["be"]
  end
  
  it "should produce a new Bundle that results from each Bundle item grabbing the item" do
    d = DuckInterpreter.new("( + - * ) 6 give").run
    d.stack.inspect.should == "[(λ(6 + ?,[\"neg\"]), λ(? - 6,[\"neg\"]), λ(6 * ?,[\"neg\"]))]"
  end
  
  it "should hand deep_copies of each item" do
    d = DuckInterpreter.new("( + - ) 6 give").step.step.step.step.step
    d.stack[-1].should_receive(:deep_copy).exactly(2).times.and_return(Int.new(6))
    d.run
  end
  
  it "should be possible to hand in multiple arguments sequentially and just have the salient ones connect" do
    d = DuckInterpreter.new("( + - * F ) 6 give 2 give").run
    d.stack.inspect.should == "[(8, -4, 12, F)]"
  end
  
  it "should work for empty Bundles" do
    d = DuckInterpreter.new("( ) 6 give").run
    d.stack.inspect.should == "[()]"
  end
  
  it "should work when the result of a message is an Array of items" do
    d = DuckInterpreter.new("( trunc ) 0.6 give").run
    d.stack.inspect.should == "[(0, 0.6)]"
  end
end
