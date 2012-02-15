require_relative '../../spec_helper'

describe "Int" do
  describe ":inc" do
    describe "it should produce the expected result" do
      it "should produce an Int with a value one larger" do
        interpreter(script:"8 inc").run.contents[-1].value.should == 9
      end
    end
  end

  describe ":dec" do
    describe "it should produce the expected result" do
      it "should produce an Int with a value one smaller" do
        interpreter(script:"8 dec").run.contents[-1].value.should == 7
      end
    end
  end
end
