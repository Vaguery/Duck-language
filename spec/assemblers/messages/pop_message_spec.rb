#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":pop" do
    it "should respond to :pop like a List does" do
      d = interpreter(script:"pop")
      numbers = (0..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers))
      d.run
      d.contents.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81 ::], 100]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched (and :halt processing)" do
      d = interpreter(script:"pop")
      numbers = (0..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers, buffer:[bool(F)]))
      d.run
      d.contents.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81 :: F], 100]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
  end
end