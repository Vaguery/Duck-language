require_relative './spec_helper'

describe "the :to_int message" do
  describe "the Bool class" do
    it "should be recognized by Bool items" do
      Bool.recognized_messages.should include(:to_int)
    end
    
    it "should produce an Int item" do
      Bool.new(false).to_int.should be_a_kind_of(Int)
    end
    
    it "should have a value of 1 if true, 0 if false" do
      Bool.new(false).to_int.value.should == 0
      Bool.new(true).to_int.value.should == 1
    end
  end
  
  describe "the Decimal class" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include(:to_int)
    end
    
    it "should produce an Int item" do
      Decimal.new(1.23).to_int.should be_a_kind_of(Int)
    end
    
    it "should have the expected value obtained by type casting in Ruby" do
      Decimal.new(123.45).to_int.value.should == 123
      Decimal.new(-0.12).to_int.value.should == 0
    end
  end
end