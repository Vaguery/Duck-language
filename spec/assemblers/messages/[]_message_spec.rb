#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":[]" do
    it "should respond to :[] like a List does" do
      d = DuckInterpreter.new("3 []")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(numbers))
      d.run
      d.stack.inspect.should == "[9]"
    end
    
    it "should include items in the Buffer" do
      d = DuckInterpreter.new("7 []")
      numbers = (0..5).collect {|i| Int.new(i*i)}
      with_buffer = Assembler.new(numbers)
      with_buffer.buffer = numbers.collect {|i| i.clone}
      d.stack.push(with_buffer)
      d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25 :: 0, 1, 4, 9, 16, 25]]"
      d.run
      d.stack.inspect.should == "[1]"
    end
  end
end