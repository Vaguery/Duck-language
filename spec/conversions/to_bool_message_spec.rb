require_relative '../spec_helper'

describe "the :to_bool message" do
  describe "the Int class" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include(:to_bool)
    end
    
    it "should produce a Bool item" do
      int(121).to_bool.should be_a_kind_of(Bool)
    end
    
    it "should have a value of true if non-negative, false if negative" do
      int(12).to_bool.value.should == true
      int(0).to_bool.value.should == true
      int(-3).to_bool.value.should == false
    end
  end
  
  describe "the Decimal class" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include(:to_bool)
    end
    
    it "should produce a Bool item" do
      decimal(12.3).to_bool.should be_a_kind_of(Bool)
    end
    
    it "should have a value of true if non-negative, false if negative" do
      decimal(12.0).to_bool.value.should == true
      decimal(0.0).to_bool.value.should == true
      decimal(-3.3).to_bool.value.should == false
    end
  end
end