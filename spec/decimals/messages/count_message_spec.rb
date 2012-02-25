#encoding: utf-8
require_relative '../../spec_helper'

describe "Decinal" do
  describe ":count message" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include :count
    end
    
    it "should return a running Iterator that has start 0 and end the value of the Int" do
      counter = int(8.0).count
      counter.should be_a_kind_of Array
      counter[0].start.should == 0
      counter[0].end.should == 8
    end
    
    it "should return an Iterator with :response set to :index" do
      decimal(8.4).count[0].response.should == :index
    end
    
    it "should produce the expected output (counting!)" do
      interpreter(script:"4.2 count").run.inspect.should == 
        "[0.0, 1.0, 2.0, 3.0, 4.0, (0.0..~(4.2)..4.2)=>[] :: :: «»]"
    end
    
    it "should produce downwards counting if negative" do
      interpreter(script:"-6.0 count").run.inspect.should ==
        "[0.0, -1.0, -2.0, -3.0, -4.0, -5.0, (0.0..~(-6.0)..-6.0)=>[] :: :: «»]"
    end
  end
end
