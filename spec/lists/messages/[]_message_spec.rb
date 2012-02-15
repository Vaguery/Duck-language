#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :[] message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:[])
    end

    it "should produce a closure, looking for a number that responds to ++" do
      List.new.[].should be_a_kind_of(Closure)
      List.new.[].needs.should == ["inc"]
    end

    it "should return the nth element of the List" do
      d = interpreter(script:"( 1 2 3 4 ) [] 2").run
      d.inspect.should == "[3 :: :: «»]"
    end

    it "should work with negative integers" do
      d = interpreter(script:"( 1 2 3 4 ) [] -12").run
      d.contents.inspect.should == "[1]"
    end

    it "should work with large positive integers" do
      d = interpreter(script:"( 1 2 3 4 ) [] 30").run
      d.contents.inspect.should == "[3]"
    end

    it "should work with an empty List" do
      d = interpreter(script:"( ) [] 1").run
      d.contents.inspect.should == "[]"
    end

    it "should not return the same object as the List contained" do
      d = interpreter(script:"( 1 2 3 4 )").run
      
      d.contents[0].should be_a_kind_of(List)
      old_three_id = d.contents[0].contents[2].object_id
      
      d.script = script("[] 2")
      d.run
      d.contents.inspect.should == "[3]"
      
      new_three_id = d.contents[0].object_id
      new_three_id.should_not == old_three_id
    end
  end
end
