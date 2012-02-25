#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe ":count_by message" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include :count_by
    end
    
    it "should return a Closure that wants another Int" do
      counter = int(8).count_by
      counter.should be_a_kind_of Closure
      counter.needs.should == ["inc"]
    end
    
    it "should produce the expected output (counting!)" do
      interpreter(script:"2 4 count_by").run.inspect.should == "[0, 2, (0..4..4)=>[] :: :: «»]"
    end
    
    it "should produce downwards counting if negative" do
      interpreter(script:"2 -6 count_by").run.inspect.should == "[0, -2, -4, (0..-6..-6)=>[] :: :: «»]"
    end
    
    it "should work for negative increments" do
      interpreter(script:"-2 3 count_by").run.inspect.should == "[0, 2, (0..3..3)=>[] :: :: «»]"
    end
    
    it "should run a long time when it's a zero increment" do
      interpreter(script:"0 3 count_by", max_ticks:100).run.inspect.should include
        ":: err:[over-complex: 102 ticks] :: «»]"
    end
  end
end
