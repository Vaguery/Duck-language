#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe ":known[]" do
    before(:each) do
      @easier = "known[]".intern
    end
    it "should be something Items recognize" do
      Item.recognized_messages.should include("known[]".intern)
    end

    it "should produce a Closure, looking for an Int" do
      Item.new.send(@easier).should be_a_kind_of(Closure)
    end

    it "should result in a Message" do
      show_me = interpreter(contents:[int(2), int(2)], script:"known[]")
      show_me.run
      show_me.inspect.should == "[:below :: :: «»]"
    end
    
    it "should use the Int value modulo the number of messages known" do
      list_length = int(3).messages.length
      
      show_me = interpreter(contents:[int(list_length), int(2)], script:"known[]")
      show_me.run
      show_me.contents[0].value.should == int(2).messages[0]
    end
    
    it "should work for negatives" do
      show_me = interpreter(contents:[int(-1), int(2)], script:"known[]")
      show_me.run
      show_me.contents[0].value.should == int(2).messages[-1]
    end
    
    it "should work for 0" do
      show_me = interpreter(contents:[int(0), int(2)], script:"known[]")
      show_me.run
      show_me.contents[0].value.should == int(2).messages[0]
    end
  end
end
