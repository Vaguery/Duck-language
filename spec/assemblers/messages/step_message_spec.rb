#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":step" do
    it "should be a recognized message" do
      Assembler.recognized_messages.should include(:step)
    end
    
    it "should process just one item from its buffer" do
      wb = Assembler.new([Int.new(1), Int.new(2)], [Int.new(3), Int.new(4)])
      wb.step.inspect.should == "[1, 2, 3 :: 4]"
    end
    
    it "should stage the item fully and generate intermediate results, but not proceed" do
      wb = Assembler.new([Message.new("+"),Int.new(1)], [Int.new(3), Int.new(4)])
      wb.step.inspect.should == "[1 :: λ(3 + ?,[\"neg\"]), 4]"
    end
  end
end