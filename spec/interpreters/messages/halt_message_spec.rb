#encoding:utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":halt" do
    it "should be a recognized message" do
      Interpreter.recognized_messages.should include(:halt)
    end
    
    it "should cease all buffer processing, when something is pushed to it" do
      wb = interpreter(script:"foo bar", contents:[int(3), int(4)], buffer:[message("zap")])
      wb.halt
      
      wrapper = interpreter(script:"F push", contents:[wb])
      wrapper.run
      wrapper.inspect.should == "[[3, 4 :: :zap, F :: «foo bar»] :: :: «»]"
    end
    
    it "should permit a step to occur without running farther" do
      wb = interpreter(script:"foo bar", 
        contents:[int(3), int(4)],
        buffer:[message("inc"), int(9)])
      wb.halt
      
      wrapper = interpreter(script:"step", contents:[wb])
      wrapper.run
      wrapper.inspect.should == "[[3 :: 5, 9 :: «foo bar»] :: :: «»]"
      
    end
    
    it "should change the Interpreter's @halted state" do
      wb = Interpreter.new
      wb.halted.should == false
      wb.halt
      wb.halted.should == true
    end    
  end
end