require_relative '../spec_helper'

describe "stack item message lists" do
  it "should be possible to query the messages an Item responds to" do
    Item.recognized_messages.should include(:be)
  end
  
  it "should not include messages that Object responds to" do
    Item.recognized_messages.should_not include(:self)
  end

  it "subclasses of Item should include stuff inherited from Item" do
    Int.recognized_messages.should_not include(:self)
    Int.recognized_messages.should include(:inc)
    Int.recognized_messages.should include(:be)
  end
end