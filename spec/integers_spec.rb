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
    
    # it should poll the StackItems to look for one that satisfies its #needs
    
    it "should poll the StackItems to look for one whose need it satisfies" do
      pending
      @ducky.step
      @ducky.stack[-1].should_receive(:want?).and_return(false)
      @ducky.step
    end

    it "should recognize IntegerItems" do
      DuckInterpreter.new("123 -912").step.stack[-1].value.should == 123
    end
  end
  
end