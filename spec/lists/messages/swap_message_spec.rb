#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :swap message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:swap)
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 3 4 ) swap").run
      d.contents.inspect.should == "[(1, 2, 4, 3)]"
    end

    it "should do nothing to Lists with one element" do
      d = interpreter(script:"( 3 ) swap").run
      d.contents.inspect.should == "[(3)]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) swap").run
      d.contents.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) 2 ( 3 ( 4 ) ) ) swap").run
      d.contents.inspect.should == "[((1), (3, (4)), 2)]"
    end
  end
end
