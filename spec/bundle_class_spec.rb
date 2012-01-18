require_relative './spec_helper'

describe "Bundle objects" do
  describe "contents" do
    it "should have an Array of contents" do
      b = Bundle.new(Int.new(1),Int.new(2))
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
  
  
  describe "needs" do
    it "should have no @needs" do
      Bundle.new.needs.should == []
    end
  end
  
  
  describe "visualization" do
    it "should list the contents" do
      Bundle.new(Int.new(1),Int.new(2)).to_s.should == "(1, 2)"
      Bundle.new.to_s.should == "()"
      Bundle.new(Bundle.new(Bundle.new(Int.new(1)),Int.new(2)),Int.new(2)).to_s.should == "(((1), 2), 2)"
    end
  end
end