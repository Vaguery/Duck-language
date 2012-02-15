#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :useful message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:useful)
    end

    it "should produce a closure, looking for any item" do
      List.new.give.should be_a_kind_of(Closure)
      List.new.give.needs.should == ["be"]
    end

    it "should produce two Lists, containing items that are useful (and not) to the separate item" do
      d = interpreter(script:"( 2 foo 4 F ) - useful").run
      d.contents.inspect.should == "[(2, 4), (:foo, F)]"
    end

    it "should produce two Lists when nothing is useful" do
      d = interpreter(script:"( foo bar baz ) - useful").run
      d.contents.inspect.should == "[(), (:foo, :bar, :baz)]"
    end

    it "should produce two Lists when all of them are useful" do
      d = interpreter(script:"( 1.1 2 33 ) ÷ useful").run
      d.contents.inspect.should == "[(1.1, 2, 33), ()]"
    end

    it "should work for empty Lists" do
      d = interpreter(script:"( ) - useful").run
      d.contents.inspect.should == "[(), ()]"
    end
  end
  
end
