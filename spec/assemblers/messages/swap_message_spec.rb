#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":swap" do
    it "should respond to :swap like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"swap",contents:[assembler(contents:numbers)])
      d.run
      d.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 100, 81 ::] :: :: «»]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched" do
      with_buffer = assembler(contents:[int(3), int(4)],buffer:[bool(T)])
      with_buffer.swap.inspect.should == "[4, 3 :: T]"
    end
  end
end