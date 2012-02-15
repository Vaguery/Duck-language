#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":step" do
    it "should be a recognized message" do
      Assembler.recognized_messages.should include(:step)
    end
    
    it "should process just one item from its buffer" do
      wb = assembler(contents:[int(1), int(2)], buffer:[int(3), int(4)])
      wb.step.inspect.should == "[1, 2, 3 :: 4]"
    end
    
    it "should stage the item fully and generate intermediate results, but not proceed" do
      wb = assembler(contents:[message("+"),int(1)], buffer:[int(3), int(4)])
      wb.step.inspect.should == "[1 :: λ(3 + ?,[\"neg\"]), 4]"
    end
    
    it "should NOT change the @halted state of the Assembler to false" do
      wb = assembler(buffer:[message("foo")])
      wb.halt
      wb.halted.should == true
      
      wb.step
      wb.inspect.should == "[:foo ::]"
      wb.halted.should == true
    end
    
    it "should not fail if the assembler is already 'settled'" do
      wb = assembler(contents:[int(8)])
      wb.step
    end
  end
end