require_relative '../../spec_helper'

describe "Item" do
  describe "the :be message" do
    it "should return the item itelf" do
      d = DuckInterpreter.new("3 be")
      d.step
      old_id = d.stack[-1].object_id
      d.run
      d.stack[-1].object_id.should == old_id
    end
  end
end
