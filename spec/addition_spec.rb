require_relative './spec_helper'

describe "IntegerItem addition" do
  describe "incomplete addition" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 add")
    end

    it "should be a message recognized by an IntegerItem" do
      @ducky.step
      @ducky.stack[-1].should respond_to("add")
    end

    it "should get passed to the right IntegerItem" do
      @ducky.step
      @ducky.stack[-1].should_receive(:instance_eval).with("add").and_return([])
      @ducky.step
    end

    it "should produce a ClosureItem" do
      @ducky.step.step
      @ducky.stack[-1].should be_a_kind_of(ClosureItem)
    end

    it "should consume the first argument" do
      @ducky.step.step
      @ducky.stack.length.should == 1
    end
    
    it "should have the right ClosureItem" do
      pending
      @ducky.step.step
      @ducky.stack[-1].value.should == "something"
      
    end
  end
end