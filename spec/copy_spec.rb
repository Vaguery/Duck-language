require_relative './spec_helper'

describe "the :copy message" do
  it "should be something any Item recognizes" do
    Int.new.should respond_to(:copy)
    Bool.new.should respond_to(:copy)
    Bundle.new.should respond_to(:copy)
  end
  
  it "should make return two copies of the top item" do
    d = DuckInterpreter.new("3 4 5 copy")
    d.run
    d.stack.inspect.should == "[3, 4, 5, 5]"
  end
  
  it "should not just replicate the pointer" do
    d = DuckInterpreter.new("3 4 5 copy")
    d.run
    d.stack[-1].object_id.should_not == d.stack[-2].object_id
  end
end