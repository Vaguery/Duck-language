require_relative '../spec_helper'

describe "the :[] message for Lists" do
  it "should be something Lists recognize" do
    List.new.should respond_to(:[])
  end
  
  it "should produce a closure, looking for a number that responds to ++" do
    List.new.[].should be_a_kind_of(Closure)
    List.new.[].needs.should == ["inc"]
  end
  
  it "should return the nth element of the List" do
    d = DuckInterpreter.new("( 1 2 3 4 ) [] 2").run
    d.stack.inspect.should == "[3]"
  end
  
  it "should work with negative integers" do
    d = DuckInterpreter.new("( 1 2 3 4 ) [] -12").run
    d.stack.inspect.should == "[1]"
  end
  
  it "should work with large positive integers" do
    d = DuckInterpreter.new("( 1 2 3 4 ) [] 30").run
    d.stack.inspect.should == "[3]"
  end
  
  it "should work with an empty List" do
    d = DuckInterpreter.new("( ) [] 1").run
    d.stack.inspect.should == "[]"
  end
  
  it "should not return the same object as the List contained" do
    d = DuckInterpreter.new("( 1 2 3 4 )").run
    d.stack[0].should be_a_kind_of(List)
    old_three_id = d.stack[0].contents[2].object_id
    d.script = "[] 2"
    d.run
    d.stack.inspect.should == "[3]"
    new_three_id = d.stack[0].object_id
    new_three_id.should_not == old_three_id
  end
end


describe "the :[] message for the Stack" do
  it "should be something the Interpreter recognizes" do
    DuckInterpreter.new.should respond_to(:[])
  end
  
  it "should produce a closure, looking for a number that responds to ++" do
    d = DuckInterpreter.new("[]").run
    d.stack[0].should be_a_kind_of(Closure)
  end
  
  it "should yank the nth element of the Stack to the top" do
    d = DuckInterpreter.new("1 2 3 4 5 2 []").run
    d.stack.inspect.should == "[1, 2, 4, 5, 3]"
  end
  
  it "should work with negative integers" do
    d = DuckInterpreter.new("1 2 3 4 5 -2 []").run
    d.stack.inspect.should == "[1, 2, 3, 5, 4]"
  end
    
  
  it "should work with large positive integers" do
    d = DuckInterpreter.new("1 2 3 4 5 12 []").run
    d.stack.inspect.should == "[1, 2, 4, 5, 3]"
  end
    
  
  it "should return the same object as the Stack originally contained (unlike List#[])" do
    d = DuckInterpreter.new("1 2 3 4 1").run
    old2 = d.stack[1].object_id
    d.script = "[]"
    d.run
    d.stack[-1].value.should == 2
    d.stack[-1].object_id.should == old2
    d.stack.inspect.should == "[1, 3, 4, 2]"
  end
  
  it "should not fail when the Stack is empty" do
    d = DuckInterpreter.new("3") # the number will get used up
    d.run
    d.script = "[]"
    d.run
    d.stack.inspect.should == "[]"
  end
end