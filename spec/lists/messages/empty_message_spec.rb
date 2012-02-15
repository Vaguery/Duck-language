require_relative '../../spec_helper'

describe "List" do
  describe "empty message" do
    before(:each) do
      @d = interpreter(script:"empty")
    end

    it "should be recognized by List items" do
      List.recognized_messages.should include(:empty)
    end

    it "should queue the item's contents" do
      @d= interpreter(script:"( 1 2 ) empty").run
      @d.contents.inspect.should == "[()]"
    end

    it "should work for an empty List" do
      s = List.new
      s.empty.contents.should == []
    end
  end
end
