require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the rotate message for the Interpreter" do
    it "should be something the Interpreter recognizes" do
      DuckInterpreter.new.should respond_to(:rotate)
    end

    it "should rotate the whole stack" do
      d = DuckInterpreter.new("1 2 3 ( 4 5 ) 6").run
      d.rotate # to avoid rotating the List
      d.stack.inspect.should == "[2, 3, (4, 5), 6, 1]"

      d.reset("1 2 3 rotate").run
      d.stack.inspect.should == "[2, 3, 1]"
    end
  end
end
