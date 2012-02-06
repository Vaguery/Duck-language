#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":swap" do
    it "should respond to :swap like a List does" do
      d = DuckInterpreter.new("swap")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(numbers))
      d.run
      d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 100, 81 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched" do
      with_buffer = Assembler.new([Int.new(3), Int.new(4)],[Bool.new(true)])
      with_buffer.swap.inspect.should == "[4, 3 :: T]"
    end
  end
end