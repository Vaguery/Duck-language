#encoding: utf-8
require_relative './spec_helper'

describe "the :if message" do
  it "should be recognized by any stack item" do
    [Int.new(192), 
      Bool.new(false), 
      Message.new("foo"),
      Closure.new(Proc.new {:bar},[])].each do |i|
      i.should respond_to(:if)
    end
  end
  
  it "should return a Closure, waiting for a Bool value" do
    poised = Int.new(192).if
    poised.should be_a_kind_of(Closure)
    poised.needs.should == ["¬"]
  end
  
  it "should replace the item if it receives a true" do
    d = DuckInterpreter.new("1 2 3 if T").run
    d.stack.inspect.should == "[1, 2, 3]"
  end
  
  it "should disappear the item if it receives a false" do
    d = DuckInterpreter.new("1 2 3 if false").run
    d.stack.inspect.should == "[1, 2]"
  end
  
  it "should work as a Message as well" do
    DuckInterpreter.new("if 1 2 3 false").run.stack.inspect.should == "[2, 3]"
    DuckInterpreter.new("if 1 2 3 true").run.stack.inspect.should == "[2, 3, 1]"
  end
end