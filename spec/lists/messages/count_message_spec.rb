require_relative '../../spec_helper'

describe "List" do
  describe "count message" do
    it "should be recognized by Lists" do
      List.new.should respond_to(:count)
    end

    it "should produce an Int containing the List's [root] length" do
      d = DuckInterpreter.new("count")
      d.stack.push List.new(List.new(Int.new(1),Int.new(2)))
      d.run
      d.stack.inspect.should == "[1]"
    end
  end
end
