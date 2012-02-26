#encoding:utf-8
require_relative '../../spec_helper'

describe "Script" do
  describe "the :length message" do
    it "should be recognized" do
      Script.recognized_messages.should include(:length)
    end
    
    it "should return the number of words (separated by whitespace)" do
      script.length.value.should == 0
      script("foo").length.value.should == 1
      script("foo bar").length.value.should == 2
    end
  end
end
