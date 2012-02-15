#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :shift message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:shift)
    end

    it "should produce an Array of results, a List and an item" do
      breaker = List.new
      breaker.contents = [int(8)]
      unshifted = breaker.shift
      unshifted.should be_a_kind_of(Array)
      unshifted[0].should be_a_kind_of(List)
      unshifted[1].should be_a_kind_of(Int)
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 ) shift").run
      d.contents.inspect.should == "[(2), 1]"
    end

    it "should do nothing when received empty Lists (leaves the List intact)" do
      d = interpreter(script:"( ) shift").run
      d.contents.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) ( 2 ( 3 4 ) ) ) shift").run
      d.contents.inspect.should == "[((2, (3, 4))), (1)]"
    end
  end
end
