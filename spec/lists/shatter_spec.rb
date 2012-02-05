require_relative '../spec_helper'

describe "shatter message" do
  before(:each) do
    @d = DuckInterpreter.new("shatter")
  end
  
  it "should be recognized by List items" do
    List.new.should respond_to(:shatter)
  end
  
  it "should queue the item's contents" do
    @d.reset("( 1 F ) shatter")
    @d.run
    @d.stack.inspect.should == "[1, F]"
  end
  
  it "should work for an empty List" do
    s = List.new
    @d.stack.push s 
    @d.run
    @d.stack.length.should == 0
  end
  
  it "should leave interior Lists intact" do
    s2 = List.new(List.new(Int.new(1),Bool.new(false)),Int.new(2))
    @d.stack.push s2
    @d.run
    @d.stack.inspect.should == "[(1, F), 2]"
  end
  
  it "should work on script-produced Lists" do
    @d.reset("( 1 2 3 4 5 ( 6 7 8 ) ) 9 shatter")
    @d.run
    @d.stack.inspect.should == "[9, 1, 2, 3, 4, 5, (6, 7, 8)]"
  end
  
  it "should not fail when the List is empty" do
    @d.reset("1121 ( ) shatter")
    lambda {@d.run}.should_not raise_error
  end
  
  it "should work with bound variables" do
    @d.reset("x x x shatter", {"x" => List.new(*[Int.new(3),Int.new(4)])}).run
    @d.stack.inspect.should == "[(3, 4), (3, 4), 3, 4]"
  end
end