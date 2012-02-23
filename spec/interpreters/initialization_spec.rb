#encoding: utf-8
require 'spec_helper'

describe "new Duck interpreter" do
  describe "created with no arguments" do
    it "should have an empty Script" do
      Interpreter.new.script == ""
    end
    
    it "should have empty contents" do
      Interpreter.new.contents.should == []
    end
    
    it "should have an empty buffer" do
      Interpreter.new.buffer.should == []
    end
    
    it "should have a binder that contains only a Proxy" do
      Interpreter.new.binder.contents.length.should == 1
      Interpreter.new.binder.contents[0].details.should include "↑(Duck::Interpreter="
    end
    
    it "should record all those as empty 'originals' for resetting" do
      Interpreter.new.initial_script.should == ""
      Interpreter.new.initial_contents.should == []
      Interpreter.new.initial_buffer.should == []
      Interpreter.new.initial_binder.contents.should == []
    end
    
    it "should have a Duck helper function" do
      interpreter.should be_a_kind_of(Interpreter)
      interpreter(script:"foo").script.inspect.should == "«foo»"
    end
  end
  
  
  describe "created with a script" do
    it "should not strip whitespace from the ends of the script" do
      interpreter(script:"   foo   ").script.inspect.should == "«   foo   »"
    end
    
    it "should totally disappear whitespace-only scripts" do
      interpreter(script:"\t\t \n\r  ").script.inspect.should == "«\t\t \n\r  »"
    end
  end
  
  describe "created with contents" do
    it "should allow you to pass in contents" do
      interpreter(contents:[int(9)]).contents.inspect.should == "[9]"
    end
    
    it "should save the contents for resetting, as a separate object" do
      ic = interpreter(contents:[int(9)])
      ic.contents[0].object_id.should_not == ic.initial_contents[0].object_id
      ic.contents[0].value.should == ic.initial_contents[0].value
    end
  end
  
  describe "created with buffer items" do
    it "should allow you to pass in a buffer list" do
      interpreter(buffer:[int(9)]).buffer.inspect.should == "[9]"
    end
    
    it "should save (a clone of) the initial buffer for resetting" do
      ib = interpreter(buffer:[int(9)])
      ib.buffer[0].object_id.should_not == ib.initial_buffer[0].object_id
      ib.buffer[0].value.should == ib.initial_buffer[0].value
    end
  end
  
  describe "created with a binder" do
    it "should allow you to pass in a binder" do
      v = variable("x",int(9))
      b = Binder.new( [v, bool(F)] )
      ibv = interpreter(binder:b)
      ibv.binder.inspect.should == "{<PROXY>, :x=9, F}"
    end
    
    it "should let you pass in a Hash of key/value pairs that become Variables" do
      h = {x:int(11), "in_list" => list((0..10).collect {|i| int(i)})}
      ibh = interpreter(binder:h)
      ibh.binder.inspect.should == "{<PROXY>, :x=11, :in_list=(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10)}"
    end
    
    it "should save (a clone of) the initial binder for resetting, less the Proxy" do
      h = {x:int(11), y:bool(F)}
      ibh = interpreter(binder:h)
      (0..1).each do |i|
        ibh.binder.contents[i].object_id.should_not == ibh.initial_binder.contents[i].object_id
        ibh.binder.contents[i+1].value.should == ibh.initial_binder.contents[i].value
      end
    end
  end
  
  
  describe "putting a little Proxy on the Binder" do
    it "should have a Proxy (to the Interpreter itself) as the first element of its binder" do
      Interpreter.new.binder.inspect.should == "{<PROXY>}"
    end
    
    it "should not save the proxy to the saved initial state" do
      Interpreter.new.initial_binder.inspect.should_not include "PROXY"
    end
  end
  
  
  describe "progress counters" do
    it "should have a #ticks attribute, set to 0 initially" do
      Interpreter.new.ticks.should == 0
    end
    
    it "should have a max_ticks attribute, set to 6000 initially" do
      Interpreter.new.max_ticks.should == 6000
    end
  end
  
  
  describe "halted state" do
    it "should permit you to set it to halted (for testing)" do
      interpreter(halted:true).halted.should == true
    end
  end
  
  
  describe "created with specified counters and limits" do
    it "should allow you to pass in a max_ticks value" do
      interpreter(max_ticks:10).max_ticks.should == 10
    end
    
    it "should allow you to pass in a ticks value (for testing, mainly)" do
      interpreter(ticks:10000).ticks.should == 10000
    end
  end
  
end