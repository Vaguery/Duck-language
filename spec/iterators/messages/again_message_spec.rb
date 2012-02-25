#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "again" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :again
    end
    
    
    it "should return itself if the index is outside the range, while resetting the index to the close end" do
      askew = Iterator.new(start:0, end:3, index:9)
      askew.again.should == askew
      askew.index.should == 3
      
      askew = Iterator.new(start:0.1, end:3.0, index:-9.0)
      askew.again.should == askew
      askew.index.should == 0.1
    end
    
    
    it "should not change the increment" do
      four_threes = Iterator.new(start:0, end:3, contents:[int(3)])
      four_threes.again.inspect.should == "[(0..0..3)=>[3], 3]"
      four_threes.again.inspect.should == "[(0..0..3)=>[3], 3]"
    end
    
    
    it "should return an Array containing only itself if nothing is bound" do
      four_threes = Iterator.new(start:0, end:3)
      four_threes.again.inspect.should == "[(0..0..3)=>[]]"
    end
  end
end
