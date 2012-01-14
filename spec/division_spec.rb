require_relative './spec_helper'

describe "division" do
  describe "bare '/' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("/")
      @ducky.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end
    
    it "should be waiting for one argument that responds to '/'" do
      @ducky.stack[-1].needs.should == ['/']
    end
  end
  
  describe "partial '/' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("3 /")
      @ducky.step.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end
    
    it "should be waiting for one Number argument" do
      @ducky.stack[-1].needs.should == ['neg']
    end
  end
  
  describe "finishing up division" do
    it "should delete the arguments and the closure" do
      ducky = DuckInterpreter.new("12 -3 /").run
      ducky.stack.length.should == 1
    end
    
    it "should produce the correct result for 'straight' division" do
      DuckInterpreter.new("27 3 /").run.stack[-1].value.should == 9
    end
    
    it "should produce the expected result for 'infix' division" do
      DuckInterpreter.new("-11 / -22").run.stack[-1].value.should == 2
    end
    
    it "should even work if the closure forms first" do
      DuckInterpreter.new("/ -12 60").run.stack[-1].value.should == -5
    end
    
    it "should do type-casting correctly so it keeps fractions" do
      pending
    end
    
    it "should not fail for division by 0" do
      lambda { DuckInterpreter.new("/ 0 60").run }.should_not raise_error
    end
    
    it "should produce the value specified in Number.divzero_result when you try to divide by 0" do
      d = DuckInterpreter.new("/ 0 60")
      d.run.stack[-1].value.should == 0
      
      d2 = DuckInterpreter.new("/ 0 60")
      Number.divzero_result=21213
      d2.run.stack[-1].value.should == 21213
    end
  end
  
  describe "delayed multiplication" do
    it "should work over complex sequences" do
      ducky = DuckInterpreter.new("1 2 * 3 4 * *")
      ducky.run
      ducky.stack[-1].value.should == 24
    end
    
    it "should produce a number when all args and methods are accounted for" do
      "11 -22 * 33 *".split.permutation do |p|
        DuckInterpreter.new(p.join(" ")).run.stack[-1].should be_a_kind_of(Int)
      end
    end
    
    it "should produce some closures when there aren't enough args" do
      "21 * -3 * *".split.permutation do |p|
        [Int,Closure].should include DuckInterpreter.new(p.join(" ")).run.stack[-1].class
      end
    end
    
  end
end