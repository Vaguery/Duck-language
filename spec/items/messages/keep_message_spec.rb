#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe "the :keep message" do
    it "should be something Items recognize" do
      Item.recognized_messages.should include(:keep)
    end
    
    it "should wrap an Item in a Binder" do
      Item.new.keep.should be_a_kind_of Binder
    end
    
    it "should return THAT item in a Binder" do
      i = Item.new("50")
      i.object_id.should == i.keep.contents[0].object_id
    end
  end
end
