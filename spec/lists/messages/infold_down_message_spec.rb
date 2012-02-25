#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :infold_down message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:infold_down)
    end
    
    it "should produce the result of each item BEING GRABBED BY the next from RIGHT to LEFT" do
      bunch = list([int(2), int(3), int(4)])
      bunch.infold_down.should be_a_kind_of(Int)
      bunch.infold_down.inspect.should == "2"
    end
    
    it "should work for empty Lists, returning nil" do
      list.infold_down.should == nil
    end
    
    it "should do all the grabbing stuff" do
      do_math_later = list( [message("+"), message("neg"), int(2)] )
      interpreter(contents:[do_math_later]).inspect.should == "[(:+, :neg, 2) :: :: «»]"
      interpreter(contents:[do_math_later], script:"infold_down").run.inspect.should == 
        "[λ(-2 + ?,[\"neg\"]) :: :: «»]"
    end
    
    it "should work even when things don't technically #grab one another, since that's how grab works" do
      interpreter(contents:[list([int(9)]*7)], script:"infold_down").run.inspect.should == "[9 :: :: «»]"
    end
    
    it "should work when an intermediate result returns an Array" do
      cause_havoc = list([
        message("shatter"),
        list( [message("*"), message("foo"),message("trunc")] )
        ])
      interpreter(contents:[cause_havoc]).inspect.should == "[(:shatter, (:*, :foo, :trunc)) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"infold_down").run.inspect.should == 
        "[:*, :foo, :trunc :: :: «»]"
    end
    
    it "should work when an intermediate result returns nil" do
      cause_havoc = list( [message("zap"), message("foo"), int(4)])
      interpreter(contents:[cause_havoc]).inspect.should == "[(:zap, :foo, 4) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"infold_down").run.inspect.should == "[:: :: «»]"
    end
  end
end