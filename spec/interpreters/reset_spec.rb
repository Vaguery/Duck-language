#encoding: utf-8
require_relative '../spec_helper'


describe "Interpreter" do
  describe "reset" do
    it "should set the script to a new string if one is passed in, or the old one otherwise" do
      d = interpreter(script:"foo bar baz")
      d.run
      d.reset
      d.script.inspect.should == "«foo bar baz»"
      d.reset(script:"1 2 3").script.inspect.should == "«1 2 3»"
    end
    
    it "should set the initial_script to the new one, if there is one" do
      d = interpreter(script:"foo bar baz")
      d.run
      d.reset
      d.reset(script:"1 2 3").initial_script.should == "1 2 3"
    end
    
    it "should set the contents to the new array passed in, or the original stuff" do
      d = interpreter(script:"",contents:[int(8)])
      d.run
      d.reset
      d.contents.inspect.should == "[8]"
      d.reset(script:"2 + 3")
      d.inspect.should == "[8 :: :: «2 + 3»]"
      d.run.inspect.should == "[10, 3 :: :: «»]"
    end
    
    it "should set the initial_contents to the new items, if there were any" do
      d = interpreter(script:"",contents:[int(8)])
      d.run
      d.reset(contents:[bool(F)])
      d.contents.inspect.should == "[F]"
      d.initial_contents.inspect.should == "[F]"
    end
    
    it "should set the buffer to the one passed in, or the original one" do
      d = interpreter(script:"",buffer:[int(8)])
      d.inspect.should == "[:: 8 :: «»]"
      d.reset(script:"foo")
      d.inspect.should == "[:: 8 :: «foo»]"
      d.initial_buffer.inspect.should == "[8]"
      d.reset(script:"", contents:[int(9)], buffer:[decimal(12.34)])
      d.inspect.should == "[9 :: 12.34 :: «»]"
      d.initial_buffer.inspect.should == "[12.34]"
    end
    
    it "should be possible to change bindings when resetting" do
      ducky = interpreter(script:"2 x +", binder:{x:int(12)})
      ducky.reset(script:"2 x +", binder:{x:int(33), y:bool(F)})
      ducky.binder.inspect.should == "{<PROXY>, :x=33, :y=F}"
    end
    
    it "should reset any temporary bindings established while running the previous state" do
      ducky = interpreter(script:"2 x +", binder:{x:int(12)})
      ducky.binder.contents << variable(:y, int(7)) # simulated a 'temp' value
      ducky.binder.inspect.should == "{<PROXY>, :x=12, :y=7}"
      ducky.reset
      ducky.binder.inspect.should == "{<PROXY>, :x=12}"
    end
    
    
    it "should set the halted to false" do
      d = Interpreter.new
      d.halt
      d.reset
      d.halted.should == false
    end
    
    it "should set the greedy_flag to true" do
      d = Interpreter.new
      d.greedy_flag = false
      d.reset
      d.greedy_flag.should == true
    end
    
    it "should set the tick counter to 0 by default" do
      d = interpreter(script:"1 2 3 4 5 6").run
      d.ticks.should == 6
      d.reset
      d.ticks.should == 0
    end
    
    it "should let you set the tick counter to another number if you want" do
      d = Interpreter.new
      d.reset(ticks:1000)
      d.ticks.should == 1000
    end
    
    it "should let you set the max_ticks limit to another number if you want" do
      d = Interpreter.new
      d.max_ticks.should == 6000
      d.reset(max_ticks:1000)
      d.max_ticks.should == 1000
    end
    
  end
end
