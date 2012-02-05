#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":[]" do
    it "should respond to :[] like a List does" do
      d = DuckInterpreter.new("3 []")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[9]"
    end
    
    it "should include items in the Buffer"
  end
end