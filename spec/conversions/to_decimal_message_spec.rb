require_relative '../spec_helper'

describe "the :to_decimal message" do
  describe "the Bool class" do
    it "should be recognized by Bool items" do
      Bool.recognized_messages.should include(:to_decimal)
    end
    
    it "should produce a Decimal item" do
      bool(F).to_decimal.should be_a_kind_of(Decimal)
    end
    
    it "should have a value of 1.0 if true, 0.0 if false" do
      bool(F).to_decimal.value.should == 0.0
      bool(T).to_decimal.value.should == 1.0
    end
  end
  
  describe "the Int class" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include(:to_decimal)
    end
    
    it "should produce a Decimal item" do
      int(123).to_decimal.should be_a_kind_of(Decimal)
    end
    
    it "should have the expected value obtained by type casting in Ruby" do
      int(123).to_decimal.value.should == 123.0
      int(-123).to_decimal.value.should == -123.0
    end
  end
end