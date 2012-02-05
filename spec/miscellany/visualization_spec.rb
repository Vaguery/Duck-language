require_relative '../spec_helper'

describe "displaying interpreter state" do
  describe "stack" do
    it "should represent the stack items with their to_s strings" do
      DuckInterpreter.new("11 22 33 foo + -").run.stack.inspect.should == "[:foo, -44]"
    end
  end
end