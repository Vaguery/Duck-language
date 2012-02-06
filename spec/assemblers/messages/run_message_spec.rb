#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":run" do
    it "should be a recognized message" do
      Assembler.recognized_messages.should include(:run)
    end
    
    it "should process just one item from its buffer" do
      wb = Assembler.new([Int.new(1), Int.new(2)], [Int.new(3), Int.new(4)])
      wb.run.inspect.should == "[1, 2, 3, 4 ::]"
    end
    
    it "should stage the item fully and generate intermediate results, but not proceed" do
      wb = Assembler.new([Message.new("*"), Message.new("+"),Int.new(1)], [Int.new(3), Int.new(4)])
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