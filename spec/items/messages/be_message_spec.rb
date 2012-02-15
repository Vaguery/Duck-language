require_relative '../../spec_helper'

describe "Item" do
  describe "the :be message" do
    it "should return the item itelf" do
      d = interpreter(script:"3 be")
      d.run
      old_id = d.contents[-1].object_id
      d.run
      d.contents[-1].object_id.should == old_id
    end
  end
end
