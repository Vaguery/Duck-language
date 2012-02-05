require_relative '../../spec_helper'

describe "Interpreter" do
  describe "Stack response to :reverse" do
    it "should be a message the Interpreter recognizes" do
      DuckInterpreter.new.should respond_to(:reverse)
    end

    it "should invert the stack if it passes through the stack items" do
      d = DuckInterpreter.new("1 2 3 4 5 reverse").run
      d.stack.inspect.should == "[5, 4, 3, 2, 1]"
    end

    it "should be OK with an empty stack" do
      d = DuckInterpreter.new("reverse")
      lambda{ d.run }.should_not raise_error
    end
  end
end
