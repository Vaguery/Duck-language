#encoding: utf-8
require_relative '../../spec_helper'
require 'timeout'

describe "Interpreter" do
  describe "the :copy message" do
    it "should be something the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:copy)
    end

    it "should make return two copies of the top contents item" do
      d = interpreter(contents:[int(3)])
      d.copy
      d.inspect.should == "[3, 3 :: :: «»]"
    end
    
    it "should not affect the buffer or script" do
      d = interpreter(contents:[int(3)], buffer:[bool(F)], script:"foo")
      d.copy
      d.inspect.should ==  "[3, 3 :: F :: «foo»]"
    end

    it "should not just replicate the pointer" do
      d = interpreter(contents:[int(3)])
      d.copy
      d.contents[0].object_id.should_not == d.contents[1].object_id
    end

    it "should not time out on some weird loop when it encounters 'copy copy'" do
      d = interpreter(script:"copy copy")
      lambda {Timeout::timeout(1) {d.run}}.should_not raise_error
    end
  end
end
