#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter items" do
  describe "class hierarchy" do
    it "should be a subclass of Assembler" do
      Interpreter.new.should be_a_kind_of(Assembler)
    end
    
  end
  
  
  describe "processing" do
    describe ":next_token behavior" do
      it "should grab a word of the script and push it onto the buffer..." do
        i = interpreter(script:"1 2 3")
        i.stub!(:process_buffer) # blocks processing
        i.next_token
        i.inspect.should == "[:: 1 :: «2 3»]"
      end
      
      it "should clear the buffer like any Assembler would" do
        i = interpreter(script:"1 2 3")
        i.next_token
        i.inspect.should == "[1 :: :: «2 3»]"
      end
    end
    
    describe ":step behavior" do
      it "should act like an Assembler, processing only one buffer item" do
        i = interpreter(script:"1 2 3", contents:[int(111)], buffer:[int(9999)])
        i.inspect.should == "[111 :: 9999 :: «1 2 3»]"
        i.step
        i.inspect.should == "[111, 9999 :: :: «1 2 3»]"
      end
      
      it "should work when there is a Binder staged, responding to a contents item" do
        bound = interpreter(contents:[message(:neg)], buffer:[Binder.new([int(3), int(4)])])
        bound.run.inspect.should == "[{3, 4}, -4 :: :: «»]"
      end

      it "should work when there is a Binder in the contents, responding to a staged item" do
        bound = interpreter(buffer:[message(:neg)], contents:[Binder.new([int(3), int(4)])])
        bound.run.inspect.should == "[{3, 4}, -4 :: :: «»]"
      end
    end
    
    describe ":run behavior" do
      it "should process the buffer if it's not empty" do
        i = interpreter(script:"", buffer:[int(9), int(10), message("+")])
        i.stub!(:next_token) # blocks buffer handling, leaving things stuck there
        i.run
        i.inspect.should == "[19 :: :: «»]"
      end
      
      it "should stop when the script is gone and the buffer is empty" do
        i = interpreter(script:"foo bar", contents:[int(3)],
          buffer:[int(9), int(10), message("+")])
        i.run
        i.inspect.should == "[3, 19, :foo, :bar :: :: «»]"
      end
    end
    
    describe ":halted Interpreters" do
      it "should just push items onto their buffers, without processing them" do
        i = interpreter(script:"1 2 3", contents:[int(111)], buffer:[int(9999)])
        i.halt
        
        d = interpreter(script:"F push", buffer:[i]).run
        d.inspect.should == "[[111 :: 9999, F :: «1 2 3»] :: :: «»]" 
      end
    end
    
    describe "tick counting" do
      it "should count every time any item is buffered or pushed to the contents" do
        i = interpreter(script:"1 2 3 4 5 6").run
        i.ticks.should == 6
        
        i = interpreter(contents:[int(3)]).run
        i.ticks.should == 0
        
        i = interpreter(buffer:[int(3)]).run
        i.ticks.should == 1
        
        i = interpreter(script:"1 2 +").run
        i.ticks.should == 7
      end
      
      it "should count steps made by Assemblers it contains" do
        a = assembler(buffer:(0..9).collect {|i| int(i)})
        i = interpreter(buffer:[message(:run),a]).run
        i.ticks.should == 14
      end
      
      it "should count steps made by Assemblers INSIDE Interpreters it contains" do
        a = assembler(buffer:(0..9).collect {|i| int(i)})
        i = interpreter(buffer:[message(:run),a])
        i2 = interpreter(buffer:[message(:run), i]).run
        i2.inspect.should == "[[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9 ::] :: :: «»] :: :: «»]"
        i2.ticks.should == 18
      end
      
      it "should not run (but can #step) if ticks > max_ticks" do
        i = interpreter(script:"1 2 3 4 5 6")
        i.max_ticks = 3
        i.run
        i.inspect.should == "[1, 2, 3 :: :: «4 5 6»]"
      end
      
      it "should halt infinite rebuffering loops" do
        i = interpreter(script:"( 3 ) to_binder )") # "collect an infinite number of threes"
        i.max_ticks = 13
        i.run
        i.inspect.should == "[:: err:[over-complex: 15 ticks] :: «»]"
      end
    end
  end
  
  
  describe "greedy_flag " do
    it "should be ON in a default interpreter" do
      Interpreter.new.greedy_flag.should == true
    end

    it "should be resettable" do
       d = Interpreter.new
       d.greedy_flag = false
       d.reset
       d.greedy_flag.should == true
    end

    describe "behavior" do
      it "should skip checking the staged item as an argument when set to false" do
        ungreedy_interpreter = interpreter(script:"+ * 1 2 3")
        if_it_were_greedy = ungreedy_interpreter.run.inspect
        # "[5 :: :: «»]"  -> (1*2)+3
        ungreedy_interpreter.reset
        ungreedy_interpreter.greedy_flag = false
        ungreedy_interpreter.run
        ungreedy_interpreter.inspect.should_not == if_it_were_greedy
        ungreedy_interpreter.inspect.should == "[:+, :*, 1, 2, 3 :: :: «»]"
      end
    end
  end
  
  
  
  
  describe "visualization" do
    it "should look like an Assembler with an extra script displayed (at the end)" do
      interpreter(script:"foo bar 1 2 +", contents:[int(9)], buffer:[int(2)]).inspect.should == 
        "[9 :: 2 :: «foo bar 1 2 +»]"
    end
    
    it "should look good when empty" do
      Interpreter.new.inspect.should == "[:: :: «»]"
    end
  end
end