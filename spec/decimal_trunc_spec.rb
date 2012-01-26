require_relative './spec_helper'

describe "the :trunc message" do
  it "should be something Decimals recognize" do
    Decimal.new(8.32).should respond_to(:trunc)
  end
  
  it "should return BOTH the Int and Decimal portions of the number" do
    d = DuckInterpreter.new("12.34 trunc").run
    d.stack.length.should == 2
    d.stack[0].value.should == 12
    d.stack[-1].value.should be_within(0.00001).of(0.34)
  end
  
  it "should be resilient to multiple application" do
    d = DuckInterpreter.new("12.34 trunc trunc").run
    d.stack.length.should == 3
    d.stack[0].value.should == 12
    d.stack[1].value.should == 0
    d.stack[-1].value.should be_within(0.00001).of(0.34)
  end
end