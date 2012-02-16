#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :infold_up message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:infold_up)
    end
    
    it "should produce the result of each item BEING GRABBED BY the next from RIGHT to LEFT" do
      bunch = list([int(2), int(3), int(4)])
      bunch.infold_up.should be_a_kind_of(Int)
      bunch.infold_up.inspect.should == "4"
    end
    
    it "should work for empty Lists, returning nil" do
      list.infold_up.should == nil
    end
    
    it "should do all the grabbing stuff" do
      do_math_later = list( [int(2), message("+") ] )
      interpreter(contents:[do_math_later]).inspect.should == "[(2, :+) :: :: «»]"
      interpreter(contents:[do_math_later], script:"infold_up").run.inspect.should == 
        "[λ(2 + ?,[\"neg\"]) :: :: «»]"
    end
    
    it "should work even when things don't technically #grab one another, since that's how grab works" do
      interpreter(contents:[list([int(9)]*7)], script:"infold_up").run.inspect.should == "[9 :: :: «»]"
    end
    
    it "should work when an intermediate result returns an Array" do
      cause_havoc = list([
        list( [message("*"), int(99), message("trunc")] ),
        message("shatter"),
        message("neg")]
        )
      interpreter(contents:[cause_havoc]).inspect.should == "[((:*, 99, :trunc), :shatter, :neg) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"infold_up").run.inspect.should == 
        "[-99 :: :: «»]"
    end
    
    it "should work when an intermediate result returns nil" do
      cause_havoc = list( [ message("foo"), message("zap"), int(4)])
      interpreter(contents:[cause_havoc]).inspect.should == "[(:foo, :zap, 4) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"infold_up").run.inspect.should == "[4 :: :: «»]"
    end
    
  end
end