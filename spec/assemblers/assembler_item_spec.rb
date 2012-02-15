#encoding:utf-8
require_relative '../spec_helper'

describe "the Assembler item" do
  it "should be a subclass of List" do
    Assembler.new.should be_a_kind_of(List)
  end
  
  it "should have a Duck module shortcut for creating a new one" do
    assembler.should be_a_kind_of(Assembler)
    assembler(contents: [message("foo")], buffer:[int(1)]).inspect.should == "[:foo :: 1]"
  end
  
  describe "deep_copy" do
    it "should transfer #ticks" do
      a = assembler(buffer:[int(3)]*122)
      a.run
      a.ticks.should == 122
      a.deep_copy.ticks.should == 122
    end
    
    it "should transfer max_ticks" do
      a = assembler
      a.max_ticks = 9000
      a.deep_copy.max_ticks.should == 9000
    end
  end
  
  describe "tick counting" do
    it "should count every time any item is buffered or pushed to the stack" do
      a = assembler(buffer:[int(3)]*7).run
      a.ticks.should == 7
      
      a = assembler(contents:[int(3)]).run
      a.ticks.should == 0
      
      a = assembler(buffer:[int(3)]).run
      a.ticks.should == 1
      
      a = assembler(buffer:[int(1), int(2),  message("+")]).run
      a.ticks.should == 7
    end
    
    it "should not run (but can #step) unless ticks < max_ticks" do
      a = assembler(buffer:[int(3)]*5)
      a.max_ticks = 3
      a.run
      a.inspect.should == "[3, 3, 3, err:[over-complex: 4 ticks] :: 3]"
    end
    
    it "should halt infinite rebuffering loops" do
      i = assembler(buffer:[Binder.new([int(3)]),Pipe.new]) # "collect an infinite number of threes"
      i.max_ticks = 1000
      i.run
      i.inspect.should == "[{3}, err:[over-complex: 1001 ticks] ::]"
    end
  end
  
  describe "processing the buffer" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should use contents items to process buffered items' needs" do
      @s.buffer = [int(7), decimal(3.5), message("+")]
      @s.run
      @s.contents.inspect.should == "[10.5]"
    end
    
    it "should be able to handle results that create an Array of results" do
      asser = Assembler.new contents:[decimal(1.125)],buffer:[message("trunc")]
      asser.run
      asser.inspect.should == "[1, 0.125 ::]" # showing it handled the Array of 2 results from :trunc
    end
    
    it "should work for methods that return nothing" do
      asser = Assembler.new contents:[message("+"),message("-")],
        buffer:[message("zap")]
      asser.run
      asser.inspect.should == "[:+ ::]"
    end
    
    it "should check to see if the buffered items are wanted by anything in the contents" do
      asser = Assembler.new contents:[message("*"), int(12)],
        buffer:[int(-2)]
      asser.run
      asser.inspect.should == "[-24 ::]" 
    end

    it "should work when the results of buffered item being consumed are nil" do
      asser = Assembler.new contents:[message("zap"), int(3)],
        buffer:[message("foo")]
      asser.run
      asser.inspect.should == "[3 ::]" 
    end

    it "should work when the results of comsuming a buffered item are an array" do
      asser = Assembler.new contents:[message("trunc"), int(3)],
        buffer:[decimal(12.25)]
      asser.run
      asser.inspect.should == "[3, 12, 0.25 ::]"
    end

    it "should return the updated Assembler" do
      foo = Assembler.new
      foo.run.should == foo
    end

    it "should fully process items already present on the buffer" do
      with_buffer = Assembler.new contents:[int(3)],
        buffer:[bool(F)]
      with_buffer.run
      with_buffer.inspect.should == "[3, F ::]"
    end
    
    it "should work when the result of processing something is a Nil" do
      zapper = Binder.new [message("zap")]
      zapped = Assembler.new contents:[zapper], buffer:[message("zap")]
      lambda { zapped.run }.should_not raise_error
    end
  end
  
  describe "the greedy_flag" do
    # should act as it did above
    it "should consider a staged item as an arg for contents items if the greedy_flag is true" do
      s = Assembler.new contents:[message("+")], buffer:[int(9)]
      s.greedy_flag = true
      s.run
      s.inspect.should == "[λ(9 + ?,[\"neg\"]) ::]"
    end
    
    it "should NOT use the staged item as an arg for a contents item" do
      s = Assembler.new contents:[message("+")], buffer:[int(9)]
      s.greedy_flag = false
      s.run
      s.inspect.should_not == "[λ(9 + ?,[\"neg\"]) ::]"
      s.inspect.should == "[:+, 9 ::]"
    end
    
    it "should be possible to toggle it on and off" do
      ungreedy = Assembler.new contents:[message("*")], buffer:[int(9)]
      ungreedy.ungreedy # sets to false
      ungreedy.run
      ungreedy.inspect.should == "[:*, 9 ::]" 
      
      ungreedy.greedy # sets flag to true
      ungreedy.buffer = [int(2)]
      ungreedy.run
      ungreedy.contents.inspect.should == "[18]"
    end
  end
  
  
  
  describe "visualization" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should be displayed in square brackets, with a double colon separating the buffer" do
      @s.contents.push(int(7))
      @s.contents.push(int(3))
      @s.inspect.should == "[7, 3 ::]"
      
      @s.buffer.push(int(11))
      @s.buffer.push(message("foo"))
      @s.inspect.should == "[7, 3 :: 11, :foo]"
      
      Assembler.new.inspect.should == "[::]"
    end
  end
end
