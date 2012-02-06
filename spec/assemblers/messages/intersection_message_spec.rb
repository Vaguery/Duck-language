#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":∩" do
    it "should respond to :∩ like a List does" do
      d = DuckInterpreter.new("∩")
      list1 = [Bool.new(false), Int.new(2), Int.new(4)]
      list2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      d.stack.push(Assembler.new(list1))
      d.stack.push(Assembler.new(list2))
      d.run
      d.stack.inspect.should == "[[2 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should compare the buffer elements within themselves with the arg's buffer, if any" do
      a1 = Assembler.new([Bool.new(false),Int.new(1)],[Int.new(2)])
      a2 = Assembler.new([Bool.new(false),Int.new(2)],[Int.new(2), Int.new(3)])
      l2 = Assembler.new([Bool.new(true),Int.new(1)])
      
      d = DuckInterpreter.new("∩")
      d.stack.push a2
      d.stack.push a1
      d.run
      d.stack.inspect.should == "[[F :: 2]]"
      
      d.reset("∩")
      d.stack.push l2
      d.stack.push a1
      d.run
      d.stack.inspect.should == "[[1 ::]]"
    end
  end
end