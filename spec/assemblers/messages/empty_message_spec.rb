#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":empty" do
    it "should respond to :empty like a List does" do
      assembler(contents:[int(1)]*12).empty.contents.length.should == 0
      assembler(contents:[int(1)]*12).empty.should be_a_kind_of(Assembler)
    end
    
    it "should also empty the buffer" do
      with_buffer = assembler(contents:[int(1)]*12)
      with_buffer.buffer.push(bool(F))
      with_buffer.empty.inspect.should == "[::]"
    end
  end
end