require_relative '../spec_helper'

describe "the :rotate message for Lists" do
  it "should be something a List recognizes" do
    List.recognized_messages.should include(:rotate)
  end
  
  it "should rotate the contents of the List" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) rotate").run
    d.stack.inspect.should == "[(2, 3, 4, 5, 1)]"
  end
  
  it "should work for an empty List" do
    d = DuckInterpreter.new("( ) rotate").run
    d.stack.inspect.should == "[()]"
  end
end


describe "the rotate message for the Interpreter" do
  it "should be something the Interpreter recognizes" do
    DuckInterpreter.new.should respond_to(:rotate)
  end
  
  it "should rotate the whole stack" do
    d = DuckInterpreter.new("1 2 3 ( 4 5 ) 6").run
    d.rotate # to avoid rotating the List
    d.stack.inspect.should == "[2, 3, (4, 5), 6, 1]"
    
    d.reset("1 2 3 rotate").run
    d.stack.inspect.should == "[2, 3, 1]"
  end
end