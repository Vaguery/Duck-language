require_relative './spec_helper'

describe "Bundle objects" do
  describe "contents" do
    it "should have an Array of contents" do
      b = Bundle.new(Int.new(1),Int.new(2))
      b.contents.should be_a_kind_of(Array)
      (b.contents.collect {|i| i.value}).should == [1,2]
    end
  end
end