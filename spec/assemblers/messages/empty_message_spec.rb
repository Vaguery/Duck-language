#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":empty" do
    it "should respond to :empty like a List does" do
      Assembler.new(*[Int.new(1)]*12).empty.contents.length.should == 0
      Assembler.new(*[Int.new(1)]*12).empty.should be_a_kind_of(Assembler)
    end
    
    it "should also empty the buffer"
  end
end