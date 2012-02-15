#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :copy message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:copy)
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 3 4 ) copy").run
      d.contents.inspect.should == "[(1, 2, 3, 4, 4)]"
    end

    it "should do nothing to Lists with one element" do
      d = interpreter(script:"( 3 ) copy").run
      d.contents.inspect.should == "[(3, 3)]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) copy").run
      d.contents.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) 2 ( 3 ( 4 ) ) ) copy").run
      d.contents.inspect.should == "[((1), 2, (3, (4)), (3, (4)))]"
    end

    it "should not produce a pointer to the same object" do
      d = interpreter(script:"( foo ) copy").run
      d.contents.inspect.should == "[(:foo, :foo)]"
      d.contents[-1].contents[0].object_id.should_not == d.contents[-1].contents[1].object_id
    end
  end
end
