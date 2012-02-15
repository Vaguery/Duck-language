#encoding: utf-8
require_relative '../spec_helper'

describe "Bool items" do
  describe "initialization" do
    it "should be a kind of Item" do
      Bool.new(false).should be_a_kind_of(Item)
    end
    
    it "should have a Duck helper method to simplify creation" do
      bool(false).should be_a_kind_of(Bool)
      bool(true).value.should == true
      bool(T).value.should == true
    end
    
    it "should be parsed from 'true' or 'false', 'T' or 'F'" do
      script("true").next_token.should be_a_kind_of(Bool)
      script("false").next_token.value.should == false
    end
    
    it "shouldn't try to parse embedded words" do
      script("betrue").next_token.should_not be_a_kind_of(Bool)
      script("falsely").next_token.should_not be_a_kind_of(Bool)
      script("This").next_token.should_not be_a_kind_of(Bool)
      script("7F").next_token.should_not be_a_kind_of(Bool)
    end
  end
  
  describe "visualization" do
    it "should look like 'T' or 'F'" do
      interpreter(script:"F true false T").run.inspect.should ==
        "[F, T, F, T :: :: «»]"
    end
  end
end