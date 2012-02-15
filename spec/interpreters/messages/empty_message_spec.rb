#encoding: utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":empty" do
    it "should be recognized by Interpreter" do
      Interpreter.recognized_messages.should include(:empty)
    end
    
    it "should clear the contents AND buffer, but not script" do
      iwcbs = interpreter(
        script:"foo bar baz",
        contents:[int(1)]*10,
        buffer:[bool(F)]*10)
      iwcbs.script.should == iwcbs.empty.script
      iwcbs.empty.inspect.should == "[:: :: «foo bar baz»]"
    end
  end
end
