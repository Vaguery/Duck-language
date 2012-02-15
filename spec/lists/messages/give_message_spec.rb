#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :give message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:give)
    end

    it "should produce a closure, looking for any item" do
      List.new.give.should be_a_kind_of(Closure)
      List.new.give.needs.should == ["be"]
    end

    it "should produce a new List that results from each List item grabbing the item" do
      d = interpreter(script:"( + - * ) 6 give").run
      d.contents.inspect.should == "[(λ(6 + ?,[\"neg\"]), λ(? - 6,[\"neg\"]), λ(6 * ?,[\"neg\"]))]"
    end

    it "should hand deep_copies of each item" do
      d = interpreter(script:"( + - ) 6").run
      d.contents[-1].should_receive(:deep_copy).exactly(2).times.and_return(int(6))
      d.script= script("give")
      d.run
    end

    it "should be possible to hand in multiple arguments sequentially and just have the salient ones connect" do
      d = interpreter(script:"( + - * F ) 6 give 2 give").run
      d.contents.inspect.should == "[(8, -4, 12, F)]"
    end

    it "should work for empty Lists" do
      d = interpreter(script:"( ) 6 give").run
      d.contents.inspect.should == "[()]"
    end

    it "should work when the result of a message is an Array of items" do
      d = interpreter(script:") known give -")
      lambda { d.run }.should_not raise_error
    end
  end
  
end
