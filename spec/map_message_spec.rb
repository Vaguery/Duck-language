#encoding: utf-8
require_relative './spec_helper'

describe "the :give message for Bundles" do
  it "should be something Bundles recognize" do
    Bundle.new.should respond_to(:map)
  end
  
  it "should produce a closure, looking for any item" do
    Bundle.new.give.should be_a_kind_of(Closure)
    Bundle.new.give.needs.should == ["be"]
  end
  
  it "should produce a new Bundle that results from each Bundle item grabbing the item" do
    d = DuckInterpreter.new("( 2 3 4 ) - map").run
    d.stack.inspect.should == "[(λ(? - 2,[\"neg\"]), λ(? - 3,[\"neg\"]), λ(? - 4,[\"neg\"]))]"
  end
  
  it "should re deep_copies of each item" do
    d = DuckInterpreter.new("( 3 2 ) * map").step.step.step.step.step
    d.stack[0].contents[0].should_receive(:deep_copy).exactly(1).times.and_return(Int.new(3))
    d.stack[0].contents[1].should_receive(:deep_copy).exactly(1).times.and_return(Int.new(2))
    d.run
  end
  
  
  it "should be possible to hand in multiple arguments sequentially and just have the salient ones connect" do
    d = DuckInterpreter.new("( 1 2 3 4 ) * map 2 give").run
    d.stack.inspect.should == "[(2, 4, 6, 8)]"
  end
end
