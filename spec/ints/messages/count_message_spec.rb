#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe ":count message" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include :count
    end
    
    it "should return a running Iterator that has start 0 and end the value of the Int" do
      counter = int(8).count
      counter.should be_a_kind_of Array
      counter[0].start.should == 0
      counter[0].end.should == 8
    end
    
    it "should return an Iterator with :response set to :index" do
      int(8).count[0].response.should == :index
    end
    
    it "should produce the expected output (counting!)" do
      interpreter(script:"4 count").run.inspect.should == "[0, 1, 2, 3, (0..4..4)=>[] :: :: «»]"
    end
    
    it "should produce downwards counting if negative" do
      interpreter(script:"-6 count").run.inspect.should == "[0, -1, -2, -3, -4, -5, (0..-6..-6)=>[] :: :: «»]"
    end
  end
end
