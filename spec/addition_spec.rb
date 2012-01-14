require_relative './spec_helper'

describe "Int addition" do
  describe "bare '+' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("+")
      @ducky.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end
    
    it "should be waiting for one argument that responds to '+'" do
      @ducky.stack[-1].needs.should == ['+']
    end
  end
  
  describe "partial '+' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 +")
      @ducky.step.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
    end
    
    it "should be waiting for one Number argument" do
      @ducky.stack[-1].needs.should == ['neg']
    end
  end
  
  describe "finishing up addition" do
    it "should delete the arguments and the closure" do
      ducky = DuckInterpreter.new("1 2 +").run
      ducky.stack.length.should == 1
    end
    
    it "should produce the correct result for 'straight' addition" do
      DuckInterpreter.new("1 2 +").run.stack[-1].value.should == 3
    end
    
    it "should produce the expected result for 'infix' addition" do
      DuckInterpreter.new("-11 + -22").run.stack[-1].value.should == -33
    end
    
    it "should even work if the closure forms first" do
      DuckInterpreter.new("+ 17 22").run.stack[-1].value.should == 39
    end
  end
  
  describe "delayed addition" do
    it "should work over complex sequences" do
      ducky = DuckInterpreter.new("1 2 + 3 4 + +")
      ducky.run
      ducky.stack[-1].value.should == 10
    end
  end
end