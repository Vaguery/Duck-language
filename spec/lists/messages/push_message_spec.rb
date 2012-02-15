#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :push message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:push)
    end

    it "should produce a closure looking for another List" do
      grabby = List.new.push
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["be"]
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 ) ( 3 4 ) push").run
      d.contents.inspect.should == "[(3, 4, (1, 2))]"
    end

    it "the Closure should be descriptive when printed" do
      d = interpreter(script:"( 1 2 3 ) push").run
      d.contents.inspect.should == "[λ((1, 2, 3).push(?),[\"be\"])]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) ( ) push").run
      d.contents.inspect.should == "[(())]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) 2 ) ( 3 ( 4 ) ) push").run
      d.contents.inspect.should == "[(3, (4), ((1), 2))]"
    end
  end
end
