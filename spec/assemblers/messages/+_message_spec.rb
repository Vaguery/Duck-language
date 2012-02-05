#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":+" do
    it "should merge the contents and buffers separately if the other arg is an Assembler" do
      a1 = Assembler.new([Int.new(1), Int.new(2)])
      a2 = Assembler.new([Bool.new(true), Bool.new(false)])
      a1.buffer.push Int.new(3)
      a2.buffer.push Decimal.new(12.34)
      
      d = DuckInterpreter.new("+")
      d.stack.push(a2)
      d.stack.push(a1)
      d.run
      d.stack.inspect.should == "[[1, 2, T, F :: 3, 12.34]]"
    end
    
    it "should keep the buffer if the arg is a List, and return an Assembler" do
      a1 = Assembler.new([Int.new(1), Int.new(2)])
      l2 = List.new([Bool.new(true), Bool.new(false)])
      a1.buffer.push Int.new(3)
      
      d = DuckInterpreter.new("+")
      d.stack.push(l2)
      d.stack.push(a1)
      d.run
      d.stack.inspect.should == "[[1, 2, T, F :: 3]]"
    end
    
  end
end