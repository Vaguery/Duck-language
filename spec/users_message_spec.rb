#encoding: utf-8
require_relative './spec_helper'

describe "the :users message for Lists" do
  it "should be something Lists recognize" do
    List.new.should respond_to(:users)
  end
  
  it "should produce a closure, looking for any item" do
    List.new.give.should be_a_kind_of(Closure)
    List.new.give.needs.should == ["be"]
  end
  
  it "should produce two Lists, containing items that can use the external item, or not" do
    d = DuckInterpreter.new("( - + / foo ) 3 users").run
    d.stack.inspect.should == "[(:-, :+, :/), (:foo)]"
  end
  
  it "should produce two Lists when the thing isn't useful" do
    d = DuckInterpreter.new("( foo bar baz ) foo users").run
    d.stack.inspect.should == "[(), (:foo, :bar, :baz)]"
  end
  
  it "should produce two Lists when the item can be used by everything" do
    d = DuckInterpreter.new("( + - - ) 8.1 users").run
    d.stack.inspect.should == "[(:+, :-, :-), ()]"
  end
  
  it "should work for empty Lists" do
    d = DuckInterpreter.new("( ) 8 users").run
    d.stack.inspect.should == "[(), ()]"
  end
end
