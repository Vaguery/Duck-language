#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "snap" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :snap
    end
    
    it "should return a Closure, looking for an Int" do
      Iterator.new.snap.should be_a_kind_of(Closure)
      Iterator.new.snap.needs.should == ["inc"]
    end
    
    it "should return two Iterators with the same Spans but different parts of the original's contents" do
      makes_numbers = Iterator.new(start:3, end:5, contents:(0..11).collect {|i| int(i)})
      snap_it = interpreter(script:"5 snap", contents:[makes_numbers]).run
      snap_it.inspect.should == "[(3..3..5)=>[0, 1, 2, 3, 4], (3..3..5)=>[5, 6, 7, 8, 9, 10, 11] :: :: «»]"
    end
  end
end
