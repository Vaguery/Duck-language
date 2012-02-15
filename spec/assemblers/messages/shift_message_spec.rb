#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":shift" do
    it "should respond to :shift like a List does" do
      d = interpreter(script:"shift")
      numbers = (0..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers))
      d.run
      d.contents.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100 ::], 0]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched (and :halt processing)" do
      d = interpreter(script:"shift")
      numbers = (5..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers, buffer:[decimal(12.34)]))
      d.run
      d.contents.inspect.should == "[[36, 49, 64, 81, 100 :: 12.34], 25]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
  end
end