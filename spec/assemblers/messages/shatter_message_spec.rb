#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":shatter" do
    it "should respond to :shatter like a List does" do
      d = DuckInterpreter.new("shatter")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]"
    end
    
    it "should release the buffered items as well"
  end
end