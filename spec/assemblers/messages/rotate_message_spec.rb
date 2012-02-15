#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":rotate" do
    it "should respond to :rotate like a List does" do
      d = interpreter(script:"rotate")
      numbers = (0..10).collect {|i| int(i*i)}
      d.contents.push(assembler(contents:numbers))
      d.run
      d.contents.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 0 ::]]"
      d.contents.each {|i| i.should be_a_kind_of(Assembler)}      
    end
    
    it "should NOT include the buffer in the rotation" do
      numbers = (3..7).collect {|i| int(i*i)}
      wb = assembler(contents:numbers,buffer:[decimal(12.34)])
      wb.rotate.inspect.should == "[16, 25, 36, 49, 9 :: 12.34]"
    end
  end
end