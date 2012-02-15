#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do

  describe ":length" do
    it "should respond to :length like a List does" do
      Assembler.new.length.should be_a_kind_of(Int)
      assembler(contents:[int(1)]*12).length.value.should == 12
    end
  
    it "should include items on its buffer" do
      with_buffer = assembler(contents:[int(1)]*12,buffer:[bool(F)])
      with_buffer.length.value.should == 13
    end
  end

end