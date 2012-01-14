require_relative './spec_helper'

describe "Integer stack item" do
  describe "initialization" do
    it "should save the value passed" do
      Int.new(33).value.should == 33
    end
  end
  
  describe "interpreting Int literals" do
    before(:each) do
      @ducky = DuckInterpreter.new("123 -912")
    end

    it "should place the IntItem onto an empty stack when it's an Int" do
      @ducky.step
      @ducky.stack[0].should be_a_kind_of(Int)
      @ducky.stack[0].value.should == 123
    end
  end
  
end