require_relative './spec_helper'

describe "grab next word" do
  
  before(:each) do
    @ducky = DuckInterpreter.new
  end
  
  it "should take the next word of script" do
    pending
    @ducky.script = "123 456"
    @ducky.step
    @ducky.queue[-1].should == "123"
  end
end