#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :+ message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:+)
    end

    it "should produce a closure looking for another List" do
      grabby = List.new.+
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["shatter"]
    end

    it "should produce the expected output" do
      d = interpreter(script:"( 1 2 ) ( 3 4 ) +").run
      d.inspect.should == "[(1, 2, 3, 4) :: :: «»]"
    end

    it "the Closure should be descriptive when printed" do
      d = interpreter(script:"( 1 2 3 ) +").run
      d.inspect.should == "[λ((1, 2, 3)+(?),[\"shatter\"]) :: :: «»]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) ( ) +").run
      d.inspect.should == "[() :: :: «»]"
    end

    it "should work with nested Lists" do
      d = interpreter(script:"( ( 1 ) 2 ) ( 3 ( 4 ) ) +").run
      d.inspect.should == "[((1), 2, 3, (4)) :: :: «»]"
    end
  end
end
