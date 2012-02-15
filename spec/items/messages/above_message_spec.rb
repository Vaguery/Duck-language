#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe "the :above message" do
    it "should be something Items recognize" do
      Item.recognized_messages.should include(:above)
    end
    
    it "should return the item and some (any) arg, in that order" do
      d = interpreter(script:"1 above 3")
      d.run
      d.inspect.should == "[3, 1 :: :: «»]"
    end
  end
end
