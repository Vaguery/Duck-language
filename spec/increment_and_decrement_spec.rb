require_relative './spec_helper'

describe "Int increment function" do
  describe "it should produce the expected result" do
    it "should produce an Int with a value one larger" do
      DuckInterpreter.new("8 inc").run.stack[-1].value.should == 9
    end
  end
end

describe "Int decrement function" do
  describe "it should produce the expected result" do
    it "should produce an Int with a value one smaller" do
      DuckInterpreter.new("8 dec").run.stack[-1].value.should == 7
    end
  end
end