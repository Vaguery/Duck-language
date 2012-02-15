require_relative '../../spec_helper'

describe "Message" do
  describe ":eql" do
    it "should create a Closure looking for a second Message" do
      m = message("foo").eql
      m.should be_a_kind_of(Closure)
      m.needs.should == ["do"]
    end

    it "should create a F Bool if the two message have different values" do
      d = interpreter(script:"foo bar eql").run
      d.contents.inspect.should == "[F]"
    end

    it "should create a T Bool if the two message have identical values" do
      d = interpreter(script:"foo foo eql").run
      d.contents.inspect.should == "[T]"
    end
  end
end
