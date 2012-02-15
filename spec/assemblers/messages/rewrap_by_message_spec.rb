#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":rewrap_by" do
    it "should respond to :rewrap_by like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"3 rewrap_by", contents:[assembler(contents:numbers)])
      d.run
      d.contents.inspect.should == "[[0, 1, 4 ::], [9, 16, 25 ::], [36, 49, 64 ::], [81, 100 ::]]"
      d.contents.each {|i| i.should be_a_kind_of(Assembler)}      
    end
    
    it "should leave the buffer associated with the last result, and halt processing" do
      numbers = (3..10).collect {|i| int(i*i)}
      d = interpreter(script:"3 rewrap_by",
        contents:[assembler(contents:numbers, buffer:[bool(F)])])
      d.run
      d.contents.inspect.should == "[[9, 16, 25 ::], [36, 49, 64 ::], [81, 100 :: F]]" 
      d.contents.each {|i| i.should be_a_kind_of(Assembler)}      
    end
  end
end