#encoding:utf-8
require_relative '../spec_helper'

describe "the Wrapper class" do
  describe "initialization" do
    it "should be a Closure" do
      w = Wrapper.new
      w.should be_a_kind_of(Closure)
      w.limit.should > 10000000
      w.needs.should == ["count", "be"]
    end
    
    it "should allow you to set a finite limit" do
      w = Wrapper.new(3)
      w.should be_a_kind_of(Closure)
      w.limit.should == 3
    end
  end
  
  describe "push things onto Lists" do
    it "it should do nothing until a List presents" do
      d = Interpreter.new("1 2 3 4 5 6 7 8 9",[],[Wrapper.new])
      d.run
      d.inspect.should == "[|(?×Infinity), 1, 2, 3, 4, 5, 6, 7, 8, 9 :: :: «»]"
    end
    
    it "it should stuff things into the list, then reappear" do
      pending
      d = Interpreter.new("( ) 1 2 3 4 5 6 7 8 9",[],[Wrapper.new])
      d.run
      d.inspect.should == "[|(?×Infinity), 1, 2, 3, 4, 5, 6, 7, 8, 9 :: :: «»]"
    end
    
    
    it "it should be possible to add a finite number of things" do
      d = Interpreter.new("1 2 3 ( ) 4 5 ( 6 7 ) 8 9",[Assembler.new],[Wrapper.new(3)])
      d.run
      d.inspect.should == "[[1, 2, 3 ::], (), 4, 5, (6, 7), 8, 9 :: :: «»]"
    end
  end
end