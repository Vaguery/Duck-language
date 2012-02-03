require_relative './spec_helper'

describe "the :rotate message for Bundles" do
  it "should be something a Bundle recognizes" do
    Bundle.recognized_messages.should include(:rotate)
  end
  
  it "should rotate the contents of the Bundle" do
    d = DuckInterpreter.new("( 1 2 3 4 5 ) rotate").run
    d.stack.inspect.should == "[(2, 3, 4, 5, 1)]"
  end
  
  it "should work for an empty Bundle" do
    d = DuckInterpreter.new("( ) rotate").run
    d.stack.inspect.should == "[()]"
  end
end