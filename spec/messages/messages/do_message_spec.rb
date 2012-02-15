require_relative '../../spec_helper'

describe "Message" do
  describe ":do" do
    it "should be recognized by a Message object" do
      Message.recognized_messages.should include(:do)
    end

    it "should re-stage the Message" do
      d = interpreter(script:"foo 1 2 3 4 5 do")
      d.run
      d.contents[-1].value.should == :foo
    end
  end
end
