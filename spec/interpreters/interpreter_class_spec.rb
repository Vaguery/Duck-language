#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter items" do
  describe "initialization" do
    it "should be a subclass of Assembler" do
      Interpreter.new.should be_a_kind_of(Assembler)
    end
    
    it "should allow a script to be passed in as a first arg" do
      Interpreter.new("foo bar").script.inspect.should == "«foo bar»"
    end
    
    it "should allow a stack array to be passed in" do
      Interpreter.new("", [Int.new(9)]).contents.inspect.should == "[9]"
    end
    
    it "should allow a buffer array to be passed in" do
      Interpreter.new("", [], [Int.new(2)]).buffer.inspect.should == "[2]"
    end
  end
  
  describe "visualization" do
    it "should look like an Assembler with an extra script displayed (at the end)" do
      Interpreter.new("foo bar 1 2 +", [Int.new(9)], [Int.new(2)]).inspect.should == 
        "[9 :: 2 :: «foo bar 1 2 +»]"
    end
    
    it "should look good when empty" do
      Interpreter.new.inspect.should == "[:: :: «»]"
    end
  end
end