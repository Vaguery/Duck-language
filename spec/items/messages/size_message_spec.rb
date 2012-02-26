require_relative '../../spec_helper'

describe "Item" do
  describe "the :size message" do
    it "should be recognized" do
      Item.recognized_messages.should include(:size)
    end
    
    
    it "should return the item and an Int = 1" do
      Item.new.size.should be_a_kind_of(Array)
      Item.new.size[0].should be_a_kind_of(Item)
      Item.new.size[1].should be_a_kind_of(Int)
      Item.new.size[1].value.should == 1
    end
  end
end
