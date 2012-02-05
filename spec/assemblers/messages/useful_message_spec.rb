#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":useful" do
    it "should respond to :useful like a List does, but return Lists" do
      d = DuckInterpreter.new("* useful")
      items = [Bool.new(false), Int.new(2), Int.new(4)]
      d.stack.push(Assembler.new(*items))
      d.run
      d.stack.inspect.should == "[[2, 4], [F]]"
      d.stack[0].should be_a_kind_of(List)
      d.stack[1].should be_a_kind_of(List)
    end
    
    it "does should check the buffer as well"
  end
end