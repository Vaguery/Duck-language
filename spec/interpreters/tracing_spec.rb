#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter" do
  describe "trace" do
    it "should have a #trace attribute, initialized to false as a default" do
      Interpreter.new.trace.should == false
    end
    
    it "should have a trace_string StringIO" do
      Interpreter.new.trace_string.should be_a_kind_of(StringIO)
    end
    
    it "should be possible to set trace to true" do
      i = Interpreter.new
      lambda { i.trace = true }.should_not raise_error
    end
    
    it "should not be cleared when #run is encountered without a reset" do
      i = interpreter(script:"1 2 3").trace!.run
      i.script = script("4 5 6")
      i.run
      i.trace_string.string.should include "3/6000 : [1, 2, 3 :: :: «»]"
      i.trace_string.string.should include "3/6000 : [1, 2, 3 :: :: «4 5 6»]"
    end
    
    it "should be cleared when #resetting an Interpreter" do
      i = interpreter(script:"1 2 3").trace!
      i.run
      i.trace_string.string.should include "3/6000 : [1, 2, 3 :: :: «»]"
      
      i.reset(script:"4 5 6")
      i.trace_string.string.should_not include "3/6000 : [1, 2, 3 :: :: «»]"
    end
    
    it "should print a flush-left informational line whenever :step is called" do
      i = Interpreter.new
      i.trace = true
      i.run
      i.trace_string.string.should include "0/6000 : [:: :: «»]"
    end
    
    it "should print an indented staging line whenever any item is staged" do
      i = interpreter(script:"1")
      i.trace = true
      i.run
      i.trace_string.string.should include "1: staging"
    end
    
    it "should print an indented push line whenever any item is added to the contents" do
      i = interpreter(script:"1")
      i.trace = true
      i.run
      i.trace_string.string.should include "moved to contents"
      i.trace_string.string.should_not include "grabbed by"
    end
    
    it "should print an indented 'wanted by' line whenever a stack item grabs the staged_item" do
      i = interpreter(script:"+ 1")
      i.trace = true
      i.run
      i.trace_string.string.should include "grabbed by"
    end
    
    it "should print an indented 'wants' line whenever it grabs a stack item" do
      i = interpreter(script:"1 +")
      i.trace = true
      i.run
      i.trace_string.string.should_not include "grabbed by"
      i.trace_string.string.should include "grabbed"
    end
  end
  
  
  describe "trace!" do
    it "should turn on the Interpreter's #trace flag" do
      Interpreter.new.trace!.trace.should == true
    end
    
    it "should return the Interpreter (for chaining)" do
      Interpreter.new.trace!.should be_a_kind_of(Interpreter)
    end
  end
  
  describe "saved_trace" do
    it "should produce the string saved in Interpreter#trace_string" do
      Interpreter.new.saved_trace.should == ""
      interpreter(script:"1 + 3").run.saved_trace.should == ""
      interpreter(script:"1 + 3").trace!.run.saved_trace.should_not == ""
    end
  end
end