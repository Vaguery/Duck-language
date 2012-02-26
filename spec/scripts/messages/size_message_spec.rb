#encoding:utf-8
require_relative '../../spec_helper'

describe "Script" do
  describe "the :size message" do
    it "should be recognized" do
      Script.recognized_messages.should include(:size)
    end
    
    it "should return an array containing self and an Int" do
      Script.new.size.should be_a_kind_of(Array)
      Script.new.size[0].should be_a_kind_of(Script)
      Script.new.size[1].should be_a_kind_of(Int)
    end
    
    it "should be 1 for an empty Script" do
      Script.new.size[1].value.should == 1
    end
    
    it "should be a count of the characters in the script" do
      script("foo bar").size[1].value.should == 8
      script("¬ ∧ ∨").size[1].value.should == 6
    end
  end
end
