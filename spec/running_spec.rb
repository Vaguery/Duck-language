require_relative './spec_helper'

describe "running a script" do
  describe "termination" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 2 3 4 5")
    end
    
    it "should end up with no script characters" do
      @ducky.run.script.length.should == 0
    end
    
    it "should end up with nothing in the queue" do
      @ducky.run.queue.length.should == 0
    end
    
    it "should end up with nothing staged" do
      @ducky.run.staged_item.should == nil
    end
    
    it "should have items on the stack (if any are left)" do
      @ducky.run.stack.length.should == 5
    end
    
    it "calling Interpreter#run should return the final interpreter" do
      @ducky.run.should be_a_kind_of(DuckInterpreter)
    end
  end
end