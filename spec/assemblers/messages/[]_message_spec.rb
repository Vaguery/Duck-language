#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":[]" do
    it "should respond to :[] like a List does" do
      d = interpreter(script:"3 []")
      numbers = (0..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers))
      d.run
      d.contents.inspect.should == "[9]"
    end
    
    it "should include items in the Buffer" do
      d = interpreter(script:"7 []")
      numbers = (0..5).collect {|i| int(i*i)}
      with_buffer = assembler(contents:numbers)
      with_buffer.buffer = numbers.collect {|i| i.clone}
      d.contents.push(with_buffer)
      d.contents.inspect.should == "[[0, 1, 4, 9, 16, 25 :: 0, 1, 4, 9, 16, 25]]"
      d.run
      d.contents.inspect.should == "[1]"
    end
  end
end