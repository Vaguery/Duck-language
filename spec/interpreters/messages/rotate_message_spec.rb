#encoding: utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the rotate message for the Interpreter" do
    it "should be something the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:rotate)
    end

    it "should rotate the whole stack" do
      d = interpreter(script:"1 2 3 ( 4 5 ) 6").run
      d.rotate
      d.inspect.should == "[2, 3, (4, 5), 6, 1 :: :: «»]"
    end
  end
end
