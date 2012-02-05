require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :pop message" do
    it "should be something the DuckInterpreter recognizes" do
      DuckInterpreter.new.should respond_to(:pop)
    end

    it "should make the top stack item disappear" do
      d = DuckInterpreter.new("3 4 5 pop +")
      d.run
      d.stack[-1].value.should == 7
    end
  end
end
