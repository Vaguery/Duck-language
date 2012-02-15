#encoding: utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :shift message for the Interpreter" do
    it "should be something the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:shift)
    end

    it "should remove the bottom item from the stack, and unshift it onto the queue" do
      d = interpreter(script:"1 2 3 4").run
      wrapper = interpreter(script:"shift", contents:[d])
      wrapper.run
      wrapper.inspect.should == "[[2, 3, 4 :: :: «»], 1 :: :: «»]"
    end
    
    it "should do nothing when the stack is empty" do
      wrapper = interpreter(script:"shift", contents:[Interpreter.new])
      wrapper.run
      wrapper.inspect.should == "[[:: :: «»] :: :: «»]"
    end
  end
end
