#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":halt" do
    it "should be a recognized message" do
      Assembler.recognized_messages.should include(:halt)
    end
    
    it "should cease all buffer processing, when an item is :pushed" do
      wb = Assembler.new([], [Int.new(3), Int.new(4)])
      wb.halt
      wb.push(Bool.new(false))
      wb.inspect.should == "[:: 3, 4, F]"
    end
    
    it "should change the Assembler's @halted state" do
      wb = Assembler.new
      wb.halted.should == false
      wb.halt
      wb.halted.should == true
    end
  end
end