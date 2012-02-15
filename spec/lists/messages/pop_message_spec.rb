#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :pop message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:pop)
    end

    it "should produce an Array of results, a List and an item" do
      breaker = List.new
      breaker.contents = [int(8)]
      unshifted = breaker.pop
      unshifted.should be_a_kind_of(Array)
      unshifted[0].should be_a_kind_of(List)
      unshifted[1].should be_a_kind_of(Int)
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 ) pop").run
      d.contents.inspect.should == "[(1), 2]"
    end

    it "should do nothing when received empty Lists (leaves the List intact)" do
      d = interpreter(script:"( ) pop").run
      d.contents.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) ( 2 ( 3 4 ) ) ) pop pop").run
      d.contents.inspect.should == "[((1)), (2), (3, 4)]"
    end
  end
end
