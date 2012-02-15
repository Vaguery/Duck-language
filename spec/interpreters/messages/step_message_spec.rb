#encoding:utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":step" do
    it "should be a recognized message" do
      Interpreter.recognized_messages.should include(:step)
    end
    
    it "should process just one item from its buffer" do
      wb = interpreter(
        contents:[int(1), int(2)],
        buffer:[int(3), int(4)])
      wb.step.inspect.should == "[1, 2, 3 :: 4 :: «»]"
    end
    
    it "should stage the item fully and generate intermediate results, but not proceed" do
      wb = interpreter(
        contents:[message("+"),int(1)],
        buffer:[int(3), int(4)])
      wb.step.inspect.should == "[1 :: λ(3 + ?,[\"neg\"]), 4 :: «»]"
    end
    
    it "should not affect the script" do
      wb = interpreter(script:"foo bar",
        contents:[message("+"),int(1)],
        buffer:[int(3), int(4)])
      wb.step.inspect.should == "[1 :: λ(3 + ?,[\"neg\"]), 4 :: «foo bar»]" 
    end
    
    it "should NOT change the @halted state of the Interpreter to false" do
      wb = interpreter(
        contents:[],buffer:[message("foo")])
      wb.halt
      wb.halted.should == true
      
      wb.step
      wb.inspect.should == "[:foo :: :: «»]"
      wb.halted.should == true
    end
  end
end