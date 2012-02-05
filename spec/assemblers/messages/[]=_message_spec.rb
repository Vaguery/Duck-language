#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":[]=" do
    it "should respond to :[]= like a List does" do
      d = DuckInterpreter.new("4 F []=")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[0, 1, 4, 9, F, 25, 36, 49, 64, 81, 100 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should include the buffer as elements for replacement" do
      d = DuckInterpreter.new("9 F []=")
      numbers = (0..3).collect {|i| Int.new(i*i)}
      short_stack = Assembler.new(*numbers)
      short_stack.buffer.push(Int.new(999))      
      d.stack.push(short_stack)
      d.stack.inspect.should == "[[0, 1, 4, 9 :: 999]]"
      
      d.run
      d.stack.inspect.should == "[[0, 1, 4, 9 :: F]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
  end
end