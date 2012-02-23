#encoding: utf-8
require_relative '../../spec_helper'

describe "Span" do
  describe "the :∪ message" do
    it "should be something a Span recognizes" do
      Span.recognized_messages.should include(:∪)
    end

    it "should produce a closure looking for another Span" do
      grabby = Span.new(1,2).∪
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["cover?"]
    end
    
    it "should return a new span covering the min to max of both Spans' ranges" do
      a = Span.new(12,19)
      b = Span.new(-12,15)
      interpreter(script:"∪", contents:[a,b]).run.inspect.should == "[(-12..19) :: :: «»]"
    end
    
    it "should ignore the fact that the two ranges might not overlap" do
      a = Span.new(17,19)
      b = Span.new(-12,3)
      interpreter(script:"∪", contents:[a,b]).run.inspect.should == "[(-12..19) :: :: «»]"
    end
    
    it "should type-cast the endpoints, if needed" do
      a = Span.new(1,10)
      b = Span.new(-1.1,3.9)
      interpreter(script:"∪", contents:[a,b]).run.inspect.should == "[(-1.1..10.0) :: :: «»]"
    end
    
    it "should type-cast the endpoints, EVEN if the Int span encloses the Decimal range" do
      a = Span.new(1,10)
      b = Span.new(3.3,7.2)
      interpreter(script:"∪", contents:[a,b]).run.inspect.should == "[(1.0..10.0) :: :: «»]"
    end
  end
end
