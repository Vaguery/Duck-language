#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":users" do
    it "should respond to :users like a List does, but return Lists" do
      d = DuckInterpreter.new("3.1 users")
      items = [Message.new("+"), Message.new("inc"), Message.new("empty")]
      d.stack.push(Assembler.new(*items))
      d.run
      d.stack.inspect.should == "[[:+ ::], [:inc, :empty ::]]"
      d.stack[0].should be_a_kind_of(List)
      d.stack[1].should be_a_kind_of(List)
    end
    
    it "should check the buffer as well"
  end
end