#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":rotate" do
    it "should respond to :rotate like a List does" do
      d = DuckInterpreter.new("rotate")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(numbers))
      d.run
      d.stack.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 0 ::]]"
      d.stack.each {|i| i.should be_a_kind_of(Assembler)}      
    end
    
    it "should NOT include the buffer in the rotation" do
      numbers = (3..7).collect {|i| Int.new(i*i)}
      wb = Assembler.new(numbers,[Decimal.new(12.34)])
      wb.rotate.inspect.should == "[16, 25, 36, 49, 9 :: 12.34]"
    end
  end
end