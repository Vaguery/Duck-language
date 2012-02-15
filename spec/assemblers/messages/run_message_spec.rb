#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":run" do
    it "should be a recognized message" do
      Assembler.recognized_messages.should include(:run)
    end
    
    it "should process all the items from its buffer" do
      wb = assembler(contents:[int(1), int(2)], buffer:[int(3), int(4)])
      wb.run.inspect.should == "[1, 2, 3, 4 ::]"
    end
    
    it "should stage all buffered items fully and generate intermediate results" do
      wb = assembler(contents:[message("*"), message("+"),int(1)],
        buffer:[int(3), int(4)])
      wb.run.inspect.should == "[16 ::]"
    end
    
    it "should change the @halted state of the Assembler to false" do
      wb = Assembler.new
      wb.halt
      wb.halted.should == true
      
      wb.run
      wb.halted.should == false
    end
  end
end