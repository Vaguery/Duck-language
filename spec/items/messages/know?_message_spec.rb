require_relative '../../spec_helper'

describe "Item" do
  describe "the :know? message" do
    it "should be recognized by all Items" do
      Item.recognized_messages.should include(:know?)
    end

    it "should return a Closure that wants something that responds to :do" do
      d = interpreter(script:"3 know?").run
      d.contents[-1].needs.should == ["do"]
    end

    it "should return a Bool indicating whether the item recognizes that message" do
      d = interpreter(script:"3 know? inc").run
      d.contents.inspect.should == "[T]"
      interpreter(script:"foo know? do").run.contents.inspect.should == "[T]"

      interpreter(script:"3 know? do").run.contents.inspect.should == "[F]"
      interpreter(script:"foo know? inc").run.contents.inspect.should == "[F]"

      interpreter(script:"know? know? do").run.contents.inspect.should == "[T]"
      # go ahead, explain that one...
    end
  end
end
