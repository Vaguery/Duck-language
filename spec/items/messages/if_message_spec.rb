#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe ":if" do
    it "should be recognized by any stack item" do
      Item.recognized_messages.should include(:if)
    end
    
    it "should return a Closure, waiting for a Bool value" do
      poised = int(192).if
      poised.should be_a_kind_of(Closure)
      poised.needs.should == ["¬"]
    end
    
    it "should replace the item if it receives a true" do
      d = interpreter(script:"1 2 3 if T").run
      d.contents.inspect.should == "[1, 2, 3]"
    end
    
    it "should disappear the item if it receives a false" do
      d = interpreter(script:"1 2 3 if false").run
      d.contents.inspect.should == "[1, 2]"
    end
    
    it "should work as a Message as well" do
      interpreter(script:"if 1 2 3 false").run.contents.inspect.should == "[2, 3]"
      interpreter(script:"if 1 2 3 true").run.contents.inspect.should == "[2, 3, 1]"
    end
  end
end
