#encoding:utf-8
require_relative './spec_helper'

describe "Bundle objects" do
  describe "contents" do
    it "should have an Array of contents" do
      b = Bundle.new(Int.new(1),Int.new(2))
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
  
  
  describe "needs" do
    it "should have no @needs" do
      Bundle.new.needs.should == []
    end
  end
  
  
  describe "Bundler closures" do
    describe "initialization" do
      it "should create an empty contents array with no args" do
        Bundler.new.contents.should == []
      end
    end
    
    
    it "should create a new Bundler closure when the interpreter sees a free-standing close paren" do
      d = DuckInterpreter.new(")").run
      d.stack[-1].should be_a_kind_of(Bundler)
      d.stack[-1].should be_a_kind_of(Closure)
    end
    
    
    it "should want to acquire anything" do
      Bundler.new.needs.should == ["be"]
    end
    
    it "should collect anything it can into a nascent Bundle" do
      d = DuckInterpreter.new("1 2 3 4 5 )").run
      d.stack[-1].inspect.should == "λ( (1, 2, 3, 4, 5, ?) )"
    end
    
    it "should be terminated if it grabs an open paren" do
      d = DuckInterpreter.new("( 1 1 1 ) 3").run
      d.stack.inspect.should == "[(1, 1, 1), 3]"
    end
    
    it "should work as expected for human-readable contents like '( 1 2 + )'" do
      d = DuckInterpreter.new("( 1 2 + )").run
      d.stack.inspect.should == "[(3)]"
    end
    
    it "should sortof work for nested parentheses, like '( 1 2 ( foo ) 3 )'" do
      d = DuckInterpreter.new("( 1 2 ( foo ) 3 )").run
      d.stack.inspect.should == "[(1, 2, (:foo), 3)]"
    end
    
    it "should produce a bundle even for human-illegible order, like ') 1 2 ('" do
      d = DuckInterpreter.new(') 1 2 (').run
      d.stack.inspect.should == "[(2, 1)]"
    end
  end
  
  
  describe "visualization" do
    it "should list the contents" do
      Bundle.new(Int.new(1),Int.new(2)).to_s.should == "(1, 2)"
      Bundle.new.to_s.should == "()"
      Bundle.new(Bundle.new(Bundle.new(Int.new(1)),Int.new(2)),Int.new(2)).to_s.should == "(((1), 2), 2)"
    end
  end
end