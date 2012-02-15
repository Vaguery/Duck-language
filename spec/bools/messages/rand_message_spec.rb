#encoding: utf-8
require_relative '../../spec_helper'

describe "Bool" do
  describe "rand" do
    it "should be recognized by Bool items" do
      Bool.recognized_messages.should include :rand
    end
    
    it "should return a Bool" do
      bool(F).rand.should be_a_kind_of(Bool)
    end
    
    it "should return a true or false depending on a call to Random#rand" do
      Random.stub!(:rand).and_return(0.4999)
      100.times { bool(T).rand.value.should == false }
      Random.stub!(:rand).and_return(0.5)
      100.times { bool(T).rand.value.should == true }
    end
  end
end
