#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":snap" do
    it "should respond to :snap like a List does" do
      d = DuckInterpreter.new("3 snap")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(numbers))
      d.run
      d.stack.inspect.should == "[[0, 1, 4 ::], [9, 16, 25, 36, 49, 64, 81, 100 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
      d.stack[1].should be_a_kind_of(Assembler)
    end
    
    it "should leave the entire buffer attached to the second part" do      
      d = DuckInterpreter.new("3 snap")
      numbers = (0..4).collect {|i| Int.new(i*i)}
      wb = Assembler.new(numbers, [Bool.new(false),Bool.new(true)])
      d.stack.push(wb)
      d.run
      d.stack.inspect.should == "[[0, 1, 4 ::], [9, 16 :: F, T]]"
    end
  end
end