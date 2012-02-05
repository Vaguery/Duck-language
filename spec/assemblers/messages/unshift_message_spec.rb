#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":unshift" do
    it "should respond to :unshift like a List does" do
      d = DuckInterpreter.new("F unshift")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[F, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should leave the buffer untouched (and :halt processing)"
  end
end