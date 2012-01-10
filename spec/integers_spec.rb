require_relative './spec_helper'

describe "Integer stack item" do
  describe "initialization" do
    it "should save the value passed" do
      IntegerItem.new(33).value.should == 33
    end
  end
end