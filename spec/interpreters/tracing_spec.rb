#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter" do
  describe "trace" do
    it "should have a #trace attribute, initialized to false as a default" do
      Interpreter.new.trace.should == false
    end
    
    it "should be possible to set trace to true" do
      i = Interpreter.new
      lambda { i.trace = true }.should_not raise_error
    end
    
    it "should print a flush-left informational line whenever :step is called"
    
    it "should print an indented staging line whenever any item is staged"
    
    it "should print an indented push line whenever any item is added to the contents"
    
    it "should print an indented 'wanted by' line whenever a stack item grabs the staged_item"
    
    it "should print an indented 'wants' line whenever it grabs a stack item"
  end
  
  
  describe "trace!" do
    it "should turn on the Interpreter's #trace flag" do
      Interpreter.new.trace!.trace.should == true
    end
    
    it "should return the Interpreter (for chaining)" do
      Interpreter.new.trace!.should be_a_kind_of(Interpreter)
    end
  end
end