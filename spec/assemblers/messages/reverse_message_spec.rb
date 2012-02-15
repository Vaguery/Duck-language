#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":reverse" do
    it "should respond to :reverse like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      as = assembler(contents:numbers)
      d = interpreter(script:"reverse",contents:[as])
      d.run
      d.inspect.should == "[[100, 81, 64, 49, 36, 25, 16, 9, 4, 1, 0 ::] :: :: «»]"
    end
    
    it "should maintain the buffer untouched" do
      with_buffer = assembler(contents:(0..10).collect {|i| int(i*i)}, buffer:[bool(F)])
      with_buffer.reverse.inspect.should == "[100, 81, 64, 49, 36, 25, 16, 9, 4, 1, 0 :: F]"
    end
  end
end