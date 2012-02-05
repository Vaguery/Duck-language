require_relative '../spec_helper'

describe "empty message" do
  before(:each) do
    @d = DuckInterpreter.new("empty")
  end
  
  it "should be recognized by List items" do
    List.new.should respond_to(:empty)
  end
  
  it "should queue the item's contents" do
    @d.reset("( 1 2 ) empty").run
    @d.stack.inspect.should == "[()]"
  end
  
  it "should work for an empty List" do
    s = List.new
    s.empty.contents.should == []
  end
end