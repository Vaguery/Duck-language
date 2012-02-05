#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":rotate" do
    it "should respond to :rotate like a List does" do
      d = DuckInterpreter.new("rotate")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 0]]"
      d.stack.each {|i| i.should be_a_kind_of(Assembler)}      
    end
    
    it "should NOT include the buffer in the rotation"
    
    it "should halt processing"
  end
end