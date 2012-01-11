require_relative './spec_helper'

describe "Int addition" do
  describe "incomplete addition" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 add")
    end

    it "should be a message recognized by an Int" do
      @ducky.step
      @ducky.stack[-1].should respond_to("add")
    end

    it "should get passed to the right Int" do
      @ducky.step
      @ducky.stack[-1].should_receive(:instance_eval).with("add").and_return([])
      @ducky.step
    end

    it "should produce a Closure" do
      @ducky.step.step
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end

    it "should consume the first argument" do
      @ducky.step.step
      @ducky.stack.length.should == 1
    end
    
    it "should create the right Closure" do
      @ducky.step.step
      @ducky.stack[-1].to_s.should == 'closure(int(1),"+",[],["neg"])'
    end
  end
end