require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :swap message" do
    it "should be something the DuckInterpreter recognizes" do
      DuckInterpreter.new.should respond_to(:swap)
    end

    it "should make the top stack item disappear" do
      d = DuckInterpreter.new("3 4 5 swap")
      d.run
      d.stack.inspect.should == "[3, 5, 4]"
    end
  end

end
