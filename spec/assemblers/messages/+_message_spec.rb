#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":+" do
    it "should merge the contents and buffers separately if the other arg is an Assembler" do
      a1 = assembler(contents:[int(1), int(2)])
      a2 = assembler(contents:[bool(T), bool(F)])
      a1.buffer.push int(3)
      a2.buffer.push decimal(12.34)
      
      d = interpreter(script: "+")
      d.contents.push(a2)
      d.contents.push(a1)
      d.run
      d.contents.inspect.should == "[[1, 2, T, F :: 3, 12.34]]"
    end
    
    it "should keep the buffer if the arg is a List, and return an Assembler" do
      a1 = assembler(contents:[int(1), int(2)])
      l2 = list([bool(T), bool(F)])
      a1.buffer.push int(3)
      
      d = interpreter(script: "+")
      d.contents.push(l2)
      d.contents.push(a1)
      d.run
      d.contents.inspect.should == "[[1, 2, T, F :: 3]]"
    end
    
  end
end