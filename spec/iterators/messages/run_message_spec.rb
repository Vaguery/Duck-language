#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "run" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :run
    end
    
    it "should return just itself if the index is outside the range, resetting the index to the near end" do
      askew = Iterator.new(start:0, end:3, index:9)
      askew.run.should == askew
      askew.index.should == 3
      
      askew = Iterator.new(start:0, end:3, index:-9)
      askew.run.should == askew
      askew.index.should == 0
    end
    
    it "should return self.step and a :run message otherwise" do
      four_threes = Iterator.new(start:0, end:3, contents:[int(3)])
      four_threes.run.inspect.should == "[(0..1..3)=>[3], 3, :run]"
    end
    
    it "should iterate over the whole specified range" do
      looper = Iterator.new(start:1, end:5, :contents =>[int(2)])
      loopy = interpreter(script:"11 run", contents:[looper])
        loopy.run
        loopy.inspect.should == "[11, 2, 2, 2, 2, (1..5..5)=>[2] :: :: «»]"
    end
    
    it "should produce the expected contents, based on the :response mode" do
      loopy = interpreter(script:"11 run",
        contents:[Iterator.new(start:1,end:5,contents:[message(:zap)])])
        loopy.run
        loopy.inspect.should == "[11, (1..5..5)=>[:zap] :: :: «»]"
    end
    
    it "should work for counters" do
      counter = Iterator.new(start:9.25, end:223.25, inc:53.0, :response => :index)
      i = interpreter(script:"run", contents:[counter]).run
      i.inspect.should == "[9.25, 62.25, 115.25, 168.25, 221.25, (9.25..~(223.25)..223.25)=>[] :: :: «»]"
    end
    
  end
end
