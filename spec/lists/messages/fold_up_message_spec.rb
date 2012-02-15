#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :fold_up message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:fold_up)
    end
    
    it "should produce the result of each item grabbing the next from left to right" do
      bunch = list([message("neg")]*7 << int(8))
      bunch.fold_up.should be_a_kind_of(Int)
      bunch.fold_up.inspect.should == "-8"
    end
    
    it "should work for empty Lists, returning nil" do
      list.fold_up.should == nil
    end
    
    it "should do all the grabbing stuff" do
      do_math_later = list( [message("+"), int(3), int(2)] )
      interpreter(contents:[do_math_later]).inspect.should == "[(:+, 3, 2) :: :: «»]"
      interpreter(contents:[do_math_later], script:"fold_up").run.inspect.should == "[5 :: :: «»]"
    end
    
    it "should work even when things don't technically #grab one another, since that's how grab works" do
      interpreter(contents:[list([int(9)]*7)], script:"fold_up").run.inspect.should == "[9 :: :: «»]"
    end
  end
end
