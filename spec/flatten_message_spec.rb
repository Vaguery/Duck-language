require_relative './spec_helper'

describe "the :flatten message for Bundles" do
  it "should be recognized by Bundles" do
    Bundle.new.should respond_to(:flatten)
  end
  
  it "should produce a Bundle as a result" do
    Bundle.new.flatten.should be_a_kind_of(Bundle)
  end
  
  it "should shatter Bundles that appear inside the receiving Bundle" do
    d = DuckInterpreter.new("( ( 1 2 ) ( 3 ) ( 4 ) ) 5 flatten").run
    d.stack.inspect.should == "[5, (1, 2, 3, 4)]"
  end
  
  it "should not affect nested bundles (behaving like Array#flatten(1))" do
    d = DuckInterpreter.new("( 1 2 ( 3 ( 4 ) ) ) 5 flatten").run
    d.stack.inspect.should == "[5, (1, 2, 3, (4))]"
  end
  
  it "should work with empty bundles" do
    d = DuckInterpreter.new("( ) 5 flatten").run
    d.stack.inspect.should == "[5, ()]"
  end
end