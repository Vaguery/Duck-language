#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":give" do
    it "should produce a List" do
      d = DuckInterpreter.new("12.25 give")
      as = Assembler.new(["neg", "trunc", "to_int"].collect {|i| Message.new(i)})
      d.stack.push(as)
      d.run
      d.stack.inspect.should == "[(-12.25, 12, 0.25, 12)]"
    end
    
    it "should merge the buffer with the contents before acting" do
      d = DuckInterpreter.new("12.25 give")
      as = Assembler.new(["neg", "trunc", "to_int"].collect {|i| Message.new(i)}, [Message.new("to_bool")])
      d.stack.push(as)
      d.run
      d.stack.inspect.should == "[(-12.25, 12, 0.25, 12, T)]"
    end
  end
end