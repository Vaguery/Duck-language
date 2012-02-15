require_relative '../../spec_helper'

describe "List" do
  describe "length message" do
    it "should be recognized by Lists" do
      List.recognized_messages.should include(:length)
    end

    it "should produce an Int containing the List's [root] length" do
      d = interpreter(script:"length")
      d.contents.push list([list([int(1),int(2)])])
      d.run
      d.contents.inspect.should == "[1]"
    end
  end
end
