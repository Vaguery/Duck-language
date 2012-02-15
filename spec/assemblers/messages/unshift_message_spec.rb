#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":unshift" do
    it "should respond to :unshift like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"F unshift",contents:[assembler(contents:numbers)])
      d.run
      d.inspect.should == "[[F, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 ::] :: :: «»]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"F unshift", contents:[assembler(contents:numbers, buffer:[bool(T)])])
      d.run
      d.inspect.should == "[[F, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 :: T] :: :: «»]"
    end
  end
end