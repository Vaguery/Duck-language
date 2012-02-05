#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":rewrap_by" do
    it "should respond to :rewrap_by like a List does" do
      d = DuckInterpreter.new("3 rewrap_by")
      numbers = (0..10).collect {|i| Int.new(i*i)}
      d.stack.push(Assembler.new(*numbers))
      d.run
      d.stack.inspect.should == "[[0, 1, 4 ::], [9, 16, 25 ::], [36, 49, 64 ::], [81, 100 ::]]"
      d.stack.each {|i| i.should be_a_kind_of(Assembler)}      
    end
    
    it "should leave the buffer associated with the last result, and halt processing"
  end
end