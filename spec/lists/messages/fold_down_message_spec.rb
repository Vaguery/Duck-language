#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :fold_down message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:fold_down)
    end
    
    it "should produce the result of each item grabbing the next from RIGHT to LEFT" do
      bunch = list([int(2), int(3)])
      bunch.fold_down.should be_a_kind_of(Int)
      bunch.fold_down.inspect.should == "3"
    end
    
    it "should work for empty Lists, returning nil" do
      list.fold_down.should == nil
    end
    
    it "should do all the grabbing stuff" do
      do_math_later = list( [int(3), int(2), message("*")] )
      interpreter(contents:[do_math_later]).inspect.should == "[(3, 2, :*) :: :: «»]"
      interpreter(contents:[do_math_later], script:"fold_down").run.inspect.should == "[6 :: :: «»]"
    end
    
    it "should work even when things don't technically #grab one another, since that's how grab works" do
      interpreter(contents:[list([int(9)]*7)], script:"fold_down").run.inspect.should == "[9 :: :: «»]"
    end
    
    it "should work when an intermediate result returns an Array" do
      cause_havoc = list([
        decimal(8.25),
        list( [message("*"), message("foo"),message("trunc")] ),
        message("shatter")
        ])
      interpreter(contents:[cause_havoc]).inspect.should == "[(8.25, (:*, :foo, :trunc), :shatter) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"fold_down").run.inspect.should == "[:foo, 66.0, 0.25 :: :: «»]"
    end
    
    it "should work when an intermediate result returns nil" do
      cause_havoc = list( [message("foo"), int(4), message("zap")])
      interpreter(contents:[cause_havoc]).inspect.should == "[(:foo, 4, :zap) :: :: «»]"
      interpreter(contents:[cause_havoc], script:"fold_down").run.inspect.should == "[:: :: «»]"
    end
    
    it "should work when an intermediate result is an Array that has a nil in it" do
      bad_boy31 = interpreter(buffer:[message(:fold_down)],
        contents:[list([message(:fold_down),Binder.new([Iterator.new]), message(:fold_down)])]).run
      bad_boy31.inspect.should == "[{(0..0..0)=>[]} :: :: «»]"
    end
    
  end
end