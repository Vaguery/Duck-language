#encoding:utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :[]= message for Lists" do
    before(:each) do
      @msg = "[]=".intern
    end

    it "should be something Lists recognize" do
      List.recognized_messages.should include(@msg)
    end
    
    it "should produce a Closure" do
      List.new.send(@msg).should be_a_kind_of(Closure)
    end
    
    it "should grab an Int as its first argument" do
      d = interpreter(script:"( 1 ) 0 []=").run
      d.contents[-1].needs.should == ["be"]
    end
    
    it "should then grab some other thing to stick into the List" do
      d = interpreter(script:"( 1 2 3 4 ) 1 :foo []=").run
      d.inspect.should == "[(1, ::foo, 3, 4) :: :: «»]"
    end


    it "should replace the nth element of the List with the new item" do
      d = interpreter(script:"( 1 2 3 4 ) 9 1 []=").run
      d.inspect.should == "[(1, 9, 3, 4) :: :: «»]"
    end

    it "should work with negative integers" do
      d = interpreter(script:"( 1 2 3 4 ) 9 -2 []=").run
      d.inspect.should == "[(1, 2, 9, 4) :: :: «»]"
    end

    it "should work with large negative integers" do
      d = interpreter(script:"( 1 2 3 4 ) 9 -112 []=").run
      d.inspect.should == "[(9, 2, 3, 4) :: :: «»]"
    end
    
    it "should work with large positive integers" do
      d = interpreter(script:"( 1 2 3 4 ) 9 12 []=").run
      d.inspect.should == "[(9, 2, 3, 4) :: :: «»]"
    end
    
    it "should insert a new element into an empty List" do
      d = interpreter(script:"( ) 9 12 []=").run
      d.inspect.should == "[(9) :: :: «»]"
    end
  end
end
