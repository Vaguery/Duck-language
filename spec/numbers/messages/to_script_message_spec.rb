#encoding: utf-8
require_relative '../../spec_helper'

describe "Number" do
  describe ":to_script message" do
    it "should return a Script item" do
      decimal(12.34).to_script.should be_a_kind_of(Script)
    end
    
    it "should contain the value as text" do
      int(111).to_script.value.should == "111"
      decimal(12.34).to_script.value.should == "12.34"
    end
  end
end
