#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :reverse message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:reverse)
    end

    it "should produce a closure looking for another List" do
      asswards = List.new.reverse
      asswards.should be_a_kind_of(List)
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 3 4 ) reverse").run
      d.contents.inspect.should == "[(4, 3, 2, 1)]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) reverse").run
      d.contents.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) 2 ( 3 ( 4 ) ) ) reverse").run
      d.contents.inspect.should == "[((3, (4)), 2, (1))]"
    end
  end
end
