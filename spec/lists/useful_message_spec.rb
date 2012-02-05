#encoding: utf-8
require_relative '../spec_helper'

describe "the :useful message for Lists" do
  it "should be something Lists recognize" do
    List.new.should respond_to(:useful)
  end
  
  it "should produce a closure, looking for any item" do
    List.new.give.should be_a_kind_of(Closure)
    List.new.give.needs.should == ["be"]
  end
  
  it "should produce two Lists, containing items that are useful (and not) to the separate item" do
    d = DuckInterpreter.new("( 2 foo 4 F ) - useful").run
    d.stack.inspect.should == "[(2, 4), (:foo, F)]"
  end
  
  it "should produce two Lists when nothing is useful" do
    d = DuckInterpreter.new("( foo bar baz ) - useful").run
    d.stack.inspect.should == "[(), (:foo, :bar, :baz)]"
  end
  
  it "should produce two Lists when all of them are useful" do
    d = DuckInterpreter.new("( 1.1 2 33 ) / useful").run
    d.stack.inspect.should == "[(1.1, 2, 33), ()]"
  end
  
  it "should work for empty Lists" do
    d = DuckInterpreter.new("( ) - useful").run
    d.stack.inspect.should == "[(), ()]"
  end
end
