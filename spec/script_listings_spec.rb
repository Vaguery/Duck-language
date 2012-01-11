#encoding: utf-8
require_relative './spec_helper'

describe "to_s representations" do
  describe "StackItems" do
    it "should be human-readable for even generic items" do
      StackItem.new("foo").to_s.should == "object(foo)"
    end
    
    it "IntegerItems should show the value" do
      IntegerItem.new("-818").to_s.should == "int(-818)"
    end
    
    it "ClosureItems should show all their arguments" do
      ci = ClosureItem.new(IntegerItem.new(8),"-",[],["neg"])
      ci.to_s.should == 'closure(int(8),"-",[],["neg"])'
    end
  end
end