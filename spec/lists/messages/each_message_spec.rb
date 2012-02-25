#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :each message" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:each)
    end

    it "should produce a running Iterator" do
      enum = list([int(1), int(2)]).each
      enum.should be_a_kind_of(Array)
      enum[0].should be_a_kind_of(Iterator)
    end
    
    it "should be running over the number of elements in the original List" do
      enum = list([int(1), int(2)]).each[0]
      enum.start.should == 0
      enum.end.should == 2
      enum.inc.should == 1
      enum.response.should == :element
    end

    it "should produce the expected output" do
      letters = ('a'..'f').collect {|i| message(i)}
      interpreter(script:"each", contents:[list(letters)]).run.inspect.should ==
        "[:a, :b, :c, :d, :e, :f, (0..6..6)=>[:a, :b, :c, :d, :e, :f] :: :: «»]"
    end

    it "should not respond to changes to the contents length" do
      letters = ('a'..'f').collect {|i| message(i)}
      interpreter(script:"each copy", contents:[list(letters)]).run.inspect.should ==
        "[:a, :b, :c, :d, :e, :f, (0..6..6)=>[:a, :b, :c, :d, :e, :f, :f] :: :: «»]"
    end
  end
end
