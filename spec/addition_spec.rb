require_relative './spec_helper'

describe "addition" do
  describe "bare '+' message" do
    before(:each) do
      @ducky = DuckInterpreter.new("+")
      @ducky.step
    end
    
    it "should produce a Message" do
      @ducky.stack[-1].should be_a_kind_of(Message)
    end
    
    it "should be waiting for one argument that responds to '+'" do
      @ducky.stack[-1].needs.should == ['+']
    end
  end
  
  
  describe "partial '+' application" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 +")
      @ducky.step.step
    end
    
    it "should produce a Closure" do
      @ducky.stack[-1].should be_a_kind_of(Closure)
      @ducky.stack[-1].should_not be_a_kind_of(Message)
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
    
    
  it "should produce a number when all args and methods are accounted for" do
    "1 2 + 3 +".split.permutation do |p|
      ducky = DuckInterpreter.new(p.join(" "))
      ducky.run.stack[-1].should be_a_kind_of(Int)
    end
  end
  
  it "should produce some closures when there aren't enough args" do
    "1 + -3 + +".split.permutation do |p|
      [Int,Message,Closure].should include DuckInterpreter.new(p.join(" ")).run.stack[-1].class
    end
  end
    
  end
end