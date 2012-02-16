#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe "the :wrap message" do
    it "should be something Items recognize" do
      Item.recognized_messages.should include(:wrap)
    end
    
    it "should wrap the Item in a List" do
      int(9).wrap.inspect.should == "(9)"
      bool(F).wrap.wrap.wrap.inspect.should == "(((F)))"
    end
  end
end
