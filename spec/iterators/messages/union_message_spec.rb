#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "the :∪ message for Iterators" do
    it "should be something an Iterator recognizes" do
      Iterator.recognized_messages.should include(:∪)
    end

    it "should produce a closure looking for another List-like thing" do
      grabby = Iterator.new.∪
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["shatter"]
    end
    
    it "should merge the contents arrays of the two args" do
      i1 = Iterator.new(start:0,end:10,contents:[int(8),int(9)])
      l2 = List.new([int(11),int(9)])
      interpreter(script:"∪", contents:[l2,i1]).run.inspect.should ==
        "[(0..0..10)=>[11, 9, 8] :: :: «»]"
    end
    
    it "should just keep the calling Iterator's range" do
      i1 = Iterator.new(start:0,end:10,contents:[int(8),int(9)])
      i2 = Iterator.new(start:-2,end:-12, contents:[int(11),int(9)])
      interpreter(script:"∪", contents:[i2,i1]).run.inspect.should ==
        "[(0..0..10)=>[11, 9, 8] :: :: «»]"
    end
    
    it "should keep the calling Iterator's :response mode" do
      i1 = Iterator.new(start:0,end:10,contents:[int(8),int(9)], :response => :index)
      i2 = Iterator.new(start:-2,end:-12, contents:[int(11),int(9)])
      interpreter(script:"∪", contents:[i2,i1]).run.contents[0].response.should == :index
    end
  end
end
