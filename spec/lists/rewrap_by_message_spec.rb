require_relative '../spec_helper'

describe "the :snap message for Lists" do
  it "should be recognized by Lists" do
    List.new.should respond_to(:rewrap_by)
  end
  
  it "should produce a Closure looking for an Int as a result" do
    List.new.rewrap_by.should be_a_kind_of(Closure)
    List.new.rewrap_by.needs.should == ["inc"]
  end
  
  it "should break the List into several new Lists, of a size indicated by the Int" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 2 rewrap_by").run
    d.stack.inspect.should == "[(1, 2), (3, 4), (5)]"
  end
  
  it "should do nothing with negative Ints" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) -1 rewrap_by").run
    d.stack.inspect.should == "[(1, 2, 3, 4, 5)]"
  end
  
  it "should do nothing with large positive Ints, or 0" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 11 rewrap_by").run
    d.stack.inspect.should == "[(1, 2, 3, 4, 5)]"
    
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 0 rewrap_by").run
    d.stack.inspect.should == "[(1, 2, 3, 4, 5)]"
  end
  
  it "should work with empty Lists" do
    d = DuckInterpreter.new("( ) 5 rewrap_by").run
    d.stack.inspect.should == "[()]"
  end
end