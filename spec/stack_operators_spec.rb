require_relative './spec_helper'

describe "the :depth message" do
  it "should return the stack depth (number of items)" do
    dd = DuckInterpreter.new("1 1 1 depth").run
    dd.stack[-1].value.should == 3
    dd.stack.length.should == 4
  end
  
  it "should work for empty stacks" do
    DuckInterpreter.new("depth").run.stack[-1].value.should == 0
  end
  
  it "should return an Int item" do
    DuckInterpreter.new("depth").run.stack[-1].should be_a_kind_of(Int)
  end
end


describe "the :pop message" do
  it "should be something the DuckInterpreter recognizes" do
    DuckInterpreter.new.should respond_to(:pop)
  end
  
  it "should make the top stack item disappear" do
    d = DuckInterpreter.new("3 4 5 pop +")
    d.run
    d.stack[-1].value.should == 7
  end
end


describe "the :swap message" do
  it "should be something the DuckInterpreter recognizes" do
    DuckInterpreter.new.should respond_to(:swap)
  end
  
  it "should make the top stack item disappear" do
    d = DuckInterpreter.new("3 4 5 swap")
    d.run
    d.stack.inspect.should == "[3, 5, 4]"
  end
end

