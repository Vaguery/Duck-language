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
  
  
  describe "processing" do
    describe ":next_token behavior" do
      it "should grab a word of the script and push it onto the buffer..." do
        i = Interpreter.new("1 2 3")
        i.stub!(:process_buffer) # blocks processing
        i.next_token
        i.inspect.should == "[:: 1 :: «2 3»]"
      end
      
      it "should clear the buffer like any Assembler would" do
        i = Interpreter.new("1 2 3")
        i.next_token
        i.inspect.should == "[1 :: :: «2 3»]"
      end
    end
    
    describe ":step behavior" do
      it "should act like an Assembler, processing only one buffer item" do
        i = Interpreter.new("1 2 3", [Int.new(111)], [Int.new(9999)])
        i.inspect.should == "[111 :: 9999 :: «1 2 3»]"
        i.step
        i.inspect.should == "[111, 9999 :: :: «1 2 3»]"
      end
    end
    
    describe ":run behavior" do
      it "should process the buffer if it's not empty" do
        i = Interpreter.new("", [], [Int.new(9), Int.new(10), Message.new("+")])
        i.stub!(:next_token) # blocks buffer handling, leaving things stuck there
        i.run
        i.inspect.should == "[19 :: :: «»]"
      end
      
      it "should stop when the script is gone and the buffer is empty" do
        i = Interpreter.new("foo bar", [Int.new(3)], [Int.new(9), Int.new(10), Message.new("+")])
        i.run
        i.inspect.should == "[3, 19, :foo, :bar :: :: «»]"
      end
    end
    
    describe ":halted Interpreters" do
      it "should just push items onto their buffers, without processing them" do
        i = Interpreter.new("1 2 3", [Int.new(111)], [Int.new(9999)])
        i.halt
        i.push(Bool.new(false))
        i.inspect.should == "[111 :: 9999, F :: «1 2 3»]"
        i.halted = false
        i.push(Bool.new(true))
        i.inspect.should == "[111, 9999, F, T :: :: «1 2 3»]"
      end
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