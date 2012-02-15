#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":∪" do
    it "should respond to :∪ like a List does" do
      d = interpreter(script:"∪")
      list1 = [bool(F), int(2), int(4)]
      list2 = [bool(T), int(2), decimal(4.0)]
      d.contents.push(assembler(contents:list1))
      d.contents.push(assembler(contents:list2))
      d.run
      d.contents.inspect.should == "[[F, 2, 4, T, 4.0 ::]]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should compare the buffer elements within themselves with the arg's buffer, if any" do
      d = interpreter(script:"∪")
      list1 = [bool(F), int(2), int(4)]
      list2 = [bool(T), int(2), decimal(4.0)]
      buffer1 = [int(11)]
      buffer2 = [int(12)]
      d.contents.push(assembler(contents:list1,buffer:buffer1))
      d.contents.push(assembler(contents:list2,buffer:buffer2))
      d.run
      d.contents.inspect.should == "[[F, 2, 4, T, 4.0 :: 11, 12]]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should work when the other item has no buffer" do
      d = interpreter(script:"∪")
      list1 = [bool(F), int(2), int(4)]
      list2 = [bool(T), int(2), decimal(4.0)]
      buffer2 = [int(12)]
      
      
      d.contents.push(list(list1))
      d.contents.push(assembler(contents:list2, buffer:buffer2))
      d.run
      d.contents.inspect.should == "[[F, 2, 4, T, 4.0 :: 12]]"
      
      d = interpreter(script:"∪")
      list1 = [bool(F), int(2), int(4)]
      list2 = [bool(T), int(2), decimal(4.0)]
      buffer2 = [int(12)]
      
      
      d.contents.push(Binder.new(list1))
      d.contents.push(assembler(contents:list2, buffer:buffer2))
      d.run
      d.contents.inspect.should == "[[F, 2, 4, T, 4.0 :: 12]]"
    end
  end
end