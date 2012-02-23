#encoding:utf-8
require_relative '../spec_helper'

describe "Proxy class" do
  describe "initialization" do
    it "should store an Item as its value" do
      target = interpreter(script:"foo bar")
      p = Proxy.new(target)
      target.object_id.should == p.value.object_id
    end
  end
  
  
  describe "recognized_messages" do
    it "should ONLY include the ones defined in the class, not inherited from Item" do
      (Proxy.recognized_messages & Item.recognized_messages).length.should == 0
    end
  end
  
  describe "visualization" do
    it "should respond to #details with a complex record" do
      target = interpreter(script:"foo bar")
      p = Proxy.new(target)
      p.details.should include "↑(Duck::Interpreter="
      p.details.should include ")↑"
    end
    
    it "should be a dstinctive ALL-CAPS thing" do
      target = interpreter(script:"foo bar")
      p = Proxy.new(target)
      p.to_s.should == "<PROXY>"
    end
  end
end