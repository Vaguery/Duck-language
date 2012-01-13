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
  
  describe "finishing up addition" do
    it "should delete the arguments and the closure" do
      pending
      DuckInterpreter.new("1 2 add").run.stack.length.should == 1
      DuckInterpreter.new("1 add 2").run.stack.length.should == 1
      DuckInterpreter.new("add 1 2").run.stack.length.should == 1
    end
    
    it "should produce the correct result for 'straight' addition" do
      pending
      DuckInterpreter.new("1 2 add").run.stack[-1].value.should == 3
    end
    
    it "should produce the expected result for 'infix' addition" do
      pending
      DuckInterpreter.new("-11 add -22").run.stack[-1].value.should == 3
    end
    
    it "should even work if the closure forms first" do
      pending
      DuckInterpreter.new("add 1 2").run.stack[-1].value.should == 3
    end
    
  end
end