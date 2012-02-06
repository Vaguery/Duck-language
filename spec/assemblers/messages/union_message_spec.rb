#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":∪" do
    it "should respond to :∪ like a List does" do
      d = DuckInterpreter.new("∪")
      list1 = [Bool.new(false), Int.new(2), Int.new(4)]
      list2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      d.stack.push(Assembler.new(list1))
      d.stack.push(Assembler.new(list2))
      d.run
      d.stack.inspect.should == "[[F, 2, 4, T, 4.0 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should compare the buffer elements within themselves with the arg's buffer, if any" do
      d = DuckInterpreter.new("∪")
      list1 = [Bool.new(false), Int.new(2), Int.new(4)]
      list2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      buffer1 = [Int.new(11)]
      buffer2 = [Int.new(12)]
      d.stack.push(Assembler.new(list1,buffer1))
      d.stack.push(Assembler.new(list2,buffer2))
      d.run
      d.stack.inspect.should == "[[F, 2, 4, T, 4.0 :: 11, 12]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
  end
end