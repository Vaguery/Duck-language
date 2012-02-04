#encoding: utf-8
require_relative './spec_helper'


describe "a Parser item" do
  before(:each) do
    @dest = Bundle.new
  end
  
  it "should be a kind of Closure" do
    Parser.new.should be_a_kind_of(Closure)
  end
  
  it "should have no needs (as a default)" do
    Parser.new.needs.should == []
  end
  
  it "should have a reasonable string representation" do
    Parser.new.to_s.should == "π(-)"
  end
  
  it "should respond to the :step message" do
    Parser.recognized_messages.should include(:step)
  end
  
  it "should remain in existence after receiving a :step message" do
    d = DuckInterpreter.new("step")
    d.stack.push Parser.new
    d.stack.push Script.new("foo bar bar") # they haven't interacted yet
    d.run
    d.stack.inspect.should ==  "[:foo, π(-), «bar bar»]"
  end
  
  it "should not return a Script that's empty" do
    d = DuckInterpreter.new("step")
    d.stack.push Parser.new
    d.stack.push Script.new("foo")
    d.run
    d.stack.inspect.should ==  "[:foo, π(-)]"
  end
  
  it "should work if the Script happens to contain no tokens or words" do
    d = DuckInterpreter.new("step")
    d.stack.push Parser.new
    d.stack.push Script.new("   \t  ")
    d.run
    d.stack.inspect.should == "[π(-)]"
  end
  
  
  it "should actually be creating the interpreted tokens" do
    d = DuckInterpreter.new("step step step")
    d.stack.push Parser.new
    d.stack.push Script.new("+ 3 8")
    d.stack.inspect.should == "[π(-), «+ 3 8»]"
    d.run
    d.stack.inspect.should == "[11, π(-)]"
  end
  
  it "should respond to the :parse message" do
    Parser.recognized_messages.should include(:parse)
  end
  
  it "should completely parse the argument Script (and disappear)" do
    d = DuckInterpreter.new("parse")
    d.stack.push Parser.new
    d.stack.push Script.new("1 2 3 4 + +")
    d.run
    d.stack.inspect.should == "[1, 9]"
  end
  
  it "should work for empty Scripts" do
    d = DuckInterpreter.new("parse")
    d.stack.push Parser.new
    d.stack.push Script.new("")
    d.run
    d.stack.inspect.should == "[]"
  end
end
