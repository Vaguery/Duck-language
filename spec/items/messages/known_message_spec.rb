#encoding: utf-8
require_relative '../../spec_helper'

describe "Item" do
  describe ":known" do
    it "should be something Items recognize" do
      Item.recognized_messages.should include(:known)
    end

    it "should produce a List" do
      Item.new.known.should be_a_kind_of(List)
    end

    it "should contain Messages" do
      Item.new.known.contents.each do |msg|
        msg.should be_a_kind_of(Message)
      end
    end

    it "should contain one Message for every thing the Item knows" do
      Item.new.known.contents.length.should == Item.recognized_messages.length
      Item.new.known.contents.each do |msg|
        Item.recognized_messages.should include(msg.value)
      end
    end

    it "should work for other subclasses of Item as expected" do
      Int.new.known.contents.length.should == Int.recognized_messages.length
      List.new.known.contents.length.should == List.recognized_messages.length
      closure([]) {}.known.contents.length.should == Closure.recognized_messages.length
    end
    
   end
end
