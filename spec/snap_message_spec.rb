require_relative './spec_helper'

describe "the :snap message for Bundles" do
  it "should be recognized by Bundles" do
    Bundle.new.should respond_to(:snap)
  end
  
  it "should produce a Closure looking for an Int as a result" do
    Bundle.new.snap.should be_a_kind_of(Closure)
    Bundle.new.snap.needs.should == ["inc"]
  end
  
  it "should break the Bundle into two parts, at the location indicated by the Int" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 2 snap").run
    d.stack.inspect.should == "[(1, 2), (3, 4, 5)]"
    
    d = DuckInterpreter.new("( 33 ) 0 snap").run
    d.stack.inspect.should == "[(), (33)]"
  end
  
  it "should work with negative Ints" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) -1 snap").run
    d.stack.inspect.should == "[(1, 2, 3, 4), (5)]"
  end
  
  it "should work with large positive and negative Ints modulo the number of items" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) -11 snap").run
    d.stack.inspect.should == "[(1, 2, 3, 4), (5)]"
    
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 11 snap").run
    d.stack.inspect.should == "[(1), (2, 3, 4, 5)]"
  end
  
  it "should work when the Int is 0" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) 0 snap").run
    d.stack.inspect.should == "[(), (1, 2, 3, 4, 5)]"
  end
  
  it "should work with empty bundles" do
    d = DuckInterpreter.new("( ) 5 snap").run
    d.stack.inspect.should == "[()]"
  end
end