require_relative './spec_helper'

describe "subtraction" do
  describe "bare '-' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("-")
      @ducky.step
    end
    
    it "should produce a Message" do
      @ducky.stack[-1].should be_a_kind_of(Message)
    end
    
    it "should be waiting for one argument that responds to '-'" do
      @ducky.stack[-1].needs.should == ['-']
    end
  end
  
  describe "partial '-' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 -")
      @ducky.step.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end
    
    it "should be waiting for one Number argument" do
      @ducky.stack[-1].needs.should == ['neg']
    end
  end
  
  describe "finishing up subtraction" do
    it "should delete the arguments and the closure" do
      ducky = DuckInterpreter.new("1 2 -").run
      ducky.stack.length.should == 1
    end
    
    it "should produce the correct result for 'straight' subtraction" do
      DuckInterpreter.new("13 27 -").run.stack[-1].value.should == -14
    end
    
    it "should produce the expected result for 'infix' subtraction" do
      DuckInterpreter.new("13 - 27").run.stack[-1].value.should == 14
    end
    
    it "should even work if the closure forms first" do
      DuckInterpreter.new("- 13 27").run.stack[-1].value.should == 14
    end
  end
  
  describe "delayed subtraction" do
    it "should work over complex sequences" do
      ducky = DuckInterpreter.new("1 2 - 3 - 4 -")
      ducky.run
      ducky.stack[-1].value.should == -8 # ((1-2)-3)-4
    end
    
    it "should produce a numeric result for any permutation (when all args are accounted for)" do
      "1 - 3 4 -".split.permutation do |p|
        DuckInterpreter.new(p.join(" ")).run.stack[-1].should be_a_kind_of(Int)
      end
    end
    
  end
end