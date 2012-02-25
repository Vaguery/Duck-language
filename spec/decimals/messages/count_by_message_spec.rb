#encoding: utf-8
require_relative '../../spec_helper'

describe "Decimal" do
  describe ":count_by message" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include :count_by
    end
    
    it "should return a Closure that wants another Int" do
      counter = decimal(8.1).count_by
      counter.should be_a_kind_of Closure
      counter.needs.should == ["neg"]
    end
    
    it "should produce the expected output (counting!)" do
      interpreter(script:"1.1 3.1 count_by").run.inspect.should == 
        "[0.0, 1.1, 2.2, (0.0..~(3.1)..3.1)=>[] :: :: «»]"
    end
    
    it "should be willing to use an Int as an increment as well" do
      interpreter(script:"2 5.1 count_by").run.inspect.should == 
        "[0.0, 2.0, 4.0, (0.0..~(5.1)..5.1)=>[] :: :: «»]"
    end
    
    it "should produce downwards counting if negative" do
      interpreter(script:"2.1 -6.7 count_by").run.inspect.should ==
        "[0.0, -2.1, -4.2, -6.300000000000001, (0.0..~(-6.7)..-6.7)=>[] :: :: «»]"
    end
    
    it "should flip around if it's a negative increment" do
      interpreter(script:"-2.25 13.2 count_by").run.inspect.should ==
        "[0.0, 2.25, 4.5, 6.75, 9.0, 11.25, (0.0..~(13.2)..13.2)=>[] :: :: «»]"
    end
    
    it "should run a long time when it's a zero increment" do
      interpreter(script:"0.0 3.0 count_by", max_ticks:100).run.inspect.should include
        ":: err:[over-complex: 102 ticks] :: «»]"
    end
  end
end
