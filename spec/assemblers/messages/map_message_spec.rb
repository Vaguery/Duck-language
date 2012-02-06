#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":map" do
    it "should produce a List" do
      d = DuckInterpreter.new("neg map")
      as = Assembler.new((0..3).collect {|i| Int.new(i*i*i)})
      d.stack.push(as)
      d.run
      d.stack.inspect.should == "[(0, -1, -8, -27)]"
    end
    
    it "should merge the buffer with the contents before acting" do
      d = DuckInterpreter.new("neg map")
      as = Assembler.new((0..3).collect {|i| Int.new(i*i*i)}, (12..13).collect {|i| Int.new(i*i*i)})
      d.stack.push(as)
      d.run
      d.stack.inspect.should == "[(0, -1, -8, -27, -1728, -2197)]"
    end
  end
end