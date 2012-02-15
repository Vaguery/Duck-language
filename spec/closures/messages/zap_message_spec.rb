require_relative '../../spec_helper'

describe "Closure" do
  describe ":zap message" do
    it "should be recognized by Closures" do
      Closure.recognized_messages.should include(:zap)
    end

    it "should delete the closure" do
      d = interpreter(script:"3 +").run
      d.contents[-1].should be_a_kind_of(Closure)
      d.script = script("zap")
      d.run
      d.contents.inspect.should == "[]"
    end

    it "should work for Messages too" do
      d = interpreter(script:"+ - *").run
      d.contents[-1].should be_a_kind_of(Message)
      d.script = script("zap")
      d.run
      d.contents.inspect.should == "[:+, :-]"
    end
  end
end
