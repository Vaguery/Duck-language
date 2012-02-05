#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":shift" do
    it "should respond to :shift like a List does" do
      d = DuckInterpreter.new("shift")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100], 0]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched (and :halt processing)"
  end
end