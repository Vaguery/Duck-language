#encoding:utf-8
require_relative '../spec_helper'

describe "the Script class" do
  it "should be a subclass of item" do
    Script.new.should be_a_kind_of(Item)
  end
  
  it "should have a @value" do
    Script.new.value.should == ""
    Script.new("foo").value.should == "foo"
  end
  
  it "should be represented on the Stack as being in guillemets" do
    d = DuckInterpreter.new("")
    d.queue.push Script.new("hi there")
    d.run
    d.stack.inspect.should == "[«hi there»]"
  end
end