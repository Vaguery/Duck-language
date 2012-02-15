require_relative '../spec_helper'

describe "displaying interpreter state" do
  describe "stack" do
    it "should represent the stack items with their to_s strings" do
      interpreter(script:"11 22 33 foo + -").run.contents.inspect.should == "[:foo, -44]"
    end
  end
end