#encoding: utf-8
require_relative './spec_helper'

describe "to_s representations" do
  describe "StackItems" do
    it "should be human-readable for even generic items" do
      Item.new("foo").to_s.should == "item(foo)"
    end
    
    it "Ints should show the value" do
      Int.new("-818").to_s.should == "int(-818)"
    end
    
    it "Closures should show all their arguments" do
      pending
    end
  end
end