#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":∩" do
    it "should respond to :∩ like a List does" do
      d = interpreter(script:"∩")
      list1 = [bool(F), int(2), int(4)]
      list2 = [bool(T), int(2), decimal(4.0)]
      d.contents.push(assembler(contents:list1))
      d.contents.push(assembler(contents:list2))
      d.run
      d.contents.inspect.should == "[[2 ::]]"
      d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should compare the buffer elements within themselves with the arg's buffer, if any" do
      a1 = assembler(contents:[bool(F),int(1)],buffer:[int(2)])
      a2 = assembler(contents:[bool(F),int(2)],buffer:[int(2), int(3)])
      a3 = assembler(contents:[bool(T),int(1)])
      
      d = interpreter(script:"∩", contents:[a1,a2])
      d.run
      d.inspect.should == "[[F :: 2] :: :: «»]"
      
      d = interpreter(script:"∩", contents:[a1,a3])
      d.run
      d.inspect.should == "[[1 ::] :: :: «»]"
    end
  end
end