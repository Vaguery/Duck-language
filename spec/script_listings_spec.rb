#encoding: utf-8
require_relative './spec_helper'

describe "to_s representations" do
  describe "StackItems" do
    it "should be human-readable for even generic items" do
      StackItem.new("foo").to_s.should == "StackItem(foo)"
    end
    
    it "IntegerItems should show the value" do
      IntegerItem.new("-818").to_s.should == "IntegerItem(-818)"
    end
    
  end
end