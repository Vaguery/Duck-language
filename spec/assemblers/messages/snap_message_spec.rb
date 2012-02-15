#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":snap" do
    it "should respond to :snap like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"3 snap", contents:[assembler(contents:numbers)])
      d.run
      d.inspect.should == "[[0, 1, 4 ::], [9, 16, 25, 36, 49, 64, 81, 100 ::] :: :: «»]"
      d.contents[0].should be_a_kind_of(Assembler)
      d.contents[1].should be_a_kind_of(Assembler)
    end
    
    it "should leave the entire buffer attached to the second part" do      
      numbers = (0..4).collect {|i| int(i*i)}
      d = interpreter(script:"3 snap",contents:[
        assembler(contents:numbers, buffer:[bool(F),bool(T)])])
      d.run
      d.inspect.should == "[[0, 1, 4 ::], [9, 16 :: F, T] :: :: «»]"
    end
  end
end