#encoding: utf-8
require_relative '../../spec_helper'

describe "Decimal" do
  describe "rand" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include :rand
    end
    
    it "should return an Int" do
      decimal(1.1).rand.should be_a_kind_of(Decimal)
    end
    
    it "should return a value in the range (0..original_value) depending on a call to Random#rand" do
      Random.should_receive(:rand).and_return(0.5)
      decimal(100.0).rand.value.should == 50.0
    end
    
    it "should return a negative value if the recipient is negative" do
      Random.should_receive(:rand).and_return(0.5)
      decimal(-100.0).rand.value.should == -50.0
    end
  end
end
