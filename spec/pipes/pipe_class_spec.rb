#encoding:utf-8
require_relative '../spec_helper'

describe "Pipe closures" do
  describe "initialization" do
    it "should create an empty contents array with no args" do
      Pipe.new.contents.should == []
    end
  end
  
  it "should create a new Pipe closure when the interpreter sees a free-standing close paren" do
    d = interpreter(script:")").run
    d.contents[-1].should be_a_kind_of(Pipe)
    d.contents[-1].should be_a_kind_of(Closure)
  end
  
  
  it "should want to acquire anything" do
    Pipe.new.needs.should == ["be"]
  end
  
  it "should collect anything it can into a nascent List" do
    d = interpreter(script:"1 2 3 4 5 )").run
    d.contents[-1].inspect.should == "λ( (1, 2, 3, 4, 5, ?) )"
  end
  
  it "should be terminated if it grabs an open paren" do
    d = interpreter(script:"( 1 1 1 ) 3").run
    d.contents.inspect.should == "[(1, 1, 1), 3]"
  end
  
  it "should work as expected for human-readable contents like '( 1 2 + )'" do
    d = interpreter(script:"( 1 2 + )").run
    d.contents.inspect.should == "[(3)]"
  end
  
  it "should sortof work for nested parentheses, like '( 1 2 ( foo ) 3 )'" do
    d = interpreter(script:"( 1 2 ( foo ) 3 )").run
    d.contents.inspect.should == "[(1, 2, (:foo), 3)]"
  end
  
  it "should produce a List even for human-illegible order, like ') 1 2 ('" do
    d = interpreter(script:') 1 2 (').run
    d.contents.inspect.should == "[(2, 1)]"
  end
end
