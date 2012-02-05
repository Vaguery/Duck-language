require_relative '../../spec_helper'

describe "List" do
  describe "the :flatten message for Lists" do
    it "should be recognized by Lists" do
      List.new.should respond_to(:flatten)
    end

    it "should produce a List as a result" do
      List.new.flatten.should be_a_kind_of(List)
    end

    it "should shatter Lists that appear inside the receiving List" do
      d = DuckInterpreter.new("( ( 1 2 ) ( 3 ) ( 4 ) ) 5 flatten").run
      d.stack.inspect.should == "[5, (1, 2, 3, 4)]"
    end

    it "should not affect nested Lists (behaving like Array#flatten(1))" do
      d = DuckInterpreter.new("( 1 2 ( 3 ( 4 ) ) ) 5 flatten").run
      d.stack.inspect.should == "[5, (1, 2, 3, (4))]"
    end

    it "should work with empty Lists" do
      d = DuckInterpreter.new("( ) 5 flatten").run
      d.stack.inspect.should == "[5, ()]"
    end
  end
end
