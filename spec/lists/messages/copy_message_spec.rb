#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :copy message for Lists" do
    it "should be something a List recognizes" do
      List.new.should respond_to(:copy)
    end

    it "should produce the expected output" do
      d = DuckInterpreter.new("( 1 2 3 4 ) copy").run
      d.stack.inspect.should == "[(1, 2, 3, 4, 4)]"
    end

    it "should do nothing to Lists with one element" do
      d = DuckInterpreter.new("( 3 ) copy").run
      d.stack.inspect.should == "[(3, 3)]"
    end

    it "should work with empty Lists" do
      d = DuckInterpreter.new("( ) copy").run
      d.stack.inspect.should == "[()]"
    end

    it "should work with nested Lists" do
      d = DuckInterpreter.new("( ( 1 ) 2 ( 3 ( 4 ) ) ) copy").run
      d.stack.inspect.should == "[((1), 2, (3, (4)), (3, (4)))]"
    end

    it "should not produce a pointer to the same object" do
      d = DuckInterpreter.new("( foo ) copy").run
      d.stack.inspect.should == "[(:foo, :foo)]"
      d.stack[-1].contents[0].object_id.should_not == d.stack[-1].contents[1].object_id
    end
  end
end
