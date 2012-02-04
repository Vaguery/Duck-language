#encoding:utf-8
require_relative './spec_helper'

describe "List objects" do
  describe "contents" do
    it "should have an Array of contents" do
      b = List.new(Int.new(1),Int.new(2))
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
    
    it "should accept a splatted array" do
      b = List.new(*[Int.new(1),Int.new(2)])
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
  
  describe "working as a variable binding" do
    it "should put itself onto the stack correctly" do
      b = List.new(*[Int.new(1),Int.new(2)])
      d = DuckInterpreter.new("x x x", {"x" => b})
      d.run.stack.inspect.should == "[(1, 2), (1, 2), (1, 2)]"
    end
  end
  
  
  describe "needs" do
    it "should have no @needs" do
      List.new.needs.should == []
    end
  end
end
  
describe "Connector closures" do
  describe "initialization" do
    it "should create an empty contents array with no args" do
      Connector.new.contents.should == []
    end
  end
  
  
  it "should create a new Connector closure when the interpreter sees a free-standing close paren" do
    d = DuckInterpreter.new(")").run
    d.stack[-1].should be_a_kind_of(Connector)
    d.stack[-1].should be_a_kind_of(Closure)
  end
  
  
  it "should want to acquire anything" do
    Connector.new.needs.should == ["be"]
  end
  
  it "should collect anything it can into a nascent List" do
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
  
  it "should produce a List even for human-illegible order, like ') 1 2 ('" do
    d = DuckInterpreter.new(') 1 2 (').run
    d.stack.inspect.should == "[(2, 1)]"
  end
  
  it "should work ungreedily when ungreedy has been toggled" do
    d = DuckInterpreter.new('ungreedy 1 2 7 9 ) - 2 3 greedy (').run
    d.stack.inspect.should == "[:-, 2, 3, (1, 2, 7, 9)]"
  end
end


describe "visualization" do
  it "should list the contents" do
    List.new(Int.new(1),Int.new(2)).to_s.should == "(1, 2)"
    List.new.to_s.should == "()"
    List.new(List.new(List.new(Int.new(1)),Int.new(2)),Int.new(2)).to_s.should == "(((1), 2), 2)"
  end
end
