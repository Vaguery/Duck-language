#encoding: utf-8
require_relative '../../spec_helper'

describe "Local" do
  describe "rand" do
    it "should be recognized by Local items" do
      Local.recognized_messages.should include :rand
    end
    
    it "should return a Local" do
      Local.new("_gg").rand.should be_a_kind_of(Local)
    end
    
    it "should random Local of lowercase letters (with underscore) the same length as it is" do
      one = Local.new("_f")
      one.rand.value.should match /_[a-z]/
      three = Local.new("_aaa")
      three.rand.value.length.should == 4
      three.rand.value.should match /_[a-z]{3}/
    end
  end
end
