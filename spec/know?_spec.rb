require_relative './spec_helper'

describe "the :know? message" do
  it "should be recognized by all Items" do
    d = DuckInterpreter.new("1 F foo +").run
    d.stack.each do |item|
      item.should respond_to(:know?)
    end
  end
  
  it "should return a Closure that wants something that responds to :do" do
    d = DuckInterpreter.new("3 know?").run
    d.stack[-1].needs.should == ["do"]
  end
  
  it "should return a Bool indicating whether the item recognizes that message" do
    d = DuckInterpreter.new("3 know? inc").run
    d.stack.inspect.should == "[T]"
    d.reset("foo know? do").run.stack.inspect.should == "[T]"
    
    d.reset("3 know? do").run.stack.inspect.should == "[F]"
    d.reset("foo know? inc").run.stack.inspect.should == "[F]"
    
    d.reset("know? know? do").run.stack.inspect.should == "[T]"
    # go ahead, explain that one...
  end
end