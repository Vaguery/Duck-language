#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "rewrap_by" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :rewrap_by
    end
    
    it "should return a Closure looking for an Int" do
      Iterator.new.rewrap_by.should be_a_kind_of(Closure)
      Iterator.new.rewrap_by.needs.should == ["inc"]
    end
    
    it "should return a number of Iterators, having rewrapped their contents and parcelled them out" do
      makes_numbers = Iterator.new(start:3, end:5, contents:(0..11).collect {|i| int(i)})
      interpreter(script:"3 rewrap_by", contents:[makes_numbers]).run.inspect.should ==
        "[(3..3..5)=>[0, 1, 2], (3..3..5)=>[3, 4, 5], (3..3..5)=>[6, 7, 8], (3..3..5)=>[9, 10, 11] :: :: «»]"
    end
  end
end
