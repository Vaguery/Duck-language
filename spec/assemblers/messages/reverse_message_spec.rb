#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":reverse" do
    it "should respond to :reverse like a List does" do
      d = DuckInterpreter.new("reverse")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(numbers))
      d.run
      d.stack.inspect.should == "[[100, 81, 64, 49, 36, 25, 16, 9, 4, 1, 0 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should maintain the buffer untouched (and :halt processing)"
  end
end