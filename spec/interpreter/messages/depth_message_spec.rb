require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :depth message" do
    it "should return the stack depth (number of items)" do
      dd = DuckInterpreter.new("1 1 1 depth").run
      dd.stack[-1].value.should == 3
      dd.stack.length.should == 4
    end

    it "should work for empty stacks" do
      DuckInterpreter.new("depth").run.stack[-1].value.should == 0
    end

    it "should return an Int item" do
      DuckInterpreter.new("depth").run.stack[-1].should be_a_kind_of(Int)
    end
  end
end
