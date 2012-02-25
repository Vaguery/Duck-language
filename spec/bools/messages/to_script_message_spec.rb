#encoding: utf-8
require_relative '../../spec_helper'

describe "Bool" do
  describe "to_script" do
    it "should be recognized by Bool items" do
      Bool.recognized_messages.should include :to_script
    end
    
    it "should return a Script with 'T' or 'F'" do
      bool(F).to_script.value.should == "F"
      bool(T).to_script.inspect.should == "«T»"
    end
  end
end
