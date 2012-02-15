#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "rand" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include :rand
    end
    
    it "should return an Int" do
      int(12).rand.should be_a_kind_of(Int)
    end
    
    it "should return a value in the range (0..original_value) depending on a call to Random#rand" do
      Random.should_receive(:rand).with(100).and_return(13)
      int(100).rand.value.should == 13
    end
    
    it "should return a negative random number if the receiver is negative" do
      Random.should_receive(:rand).with(100).and_return(13)
      int(-100).rand.value.should == -13
    end
  end
end
