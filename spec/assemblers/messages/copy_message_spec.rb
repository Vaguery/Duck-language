#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":copy" do
    it "should respond to :copy like a List does" do
      d = DuckInterpreter.new("copy")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 100]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should copy the buffer as well (and :halt processing)"
  end
end