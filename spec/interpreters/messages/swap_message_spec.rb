#encoding: utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :swap message" do
    it "should be something the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:swap)
    end

    it "should make the top stack item disappear" do
      d = interpreter(script:"3 4 5")
      wrapper = interpreter(script:"run swap", contents:[d])
      wrapper.run
      wrapper.inspect.should ==  "[[3, 5, 4 :: :: «»] :: :: «»]"
    end
  end

end
