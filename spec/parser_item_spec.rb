#encoding: utf-8
require_relative './spec_helper'


describe "a Parser item" do
  before(:each) do
    @dest = Bundle.new
  end
  
  it "should be a kind of Closure" do
    Parser.new.should be_a_kind_of(Closure)
  end
  
  it "should want a source string" do
    Parser.new.needs.should == ["lowercase"]
  end
  
  it "should parse one word off the string it obtains, returning the token and the reduced script" do
    d = DuckInterpreter.new("")
    d.stack.push Parser.new
    d.queue.push Script.new("foo bar")
    d.run
    d.stack.inspect.should == "[:foo, «bar»]"
  end
end
