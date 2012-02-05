#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :unshift message for Lists" do
    it "should be something a List recognizes" do
      List.new.should respond_to(:unshift)
    end

    it "should produce a closure looking for another List" do
      grabby = List.new.unshift
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["be"]
    end

    it "should produce the expected output" do
      d = DuckInterpreter.new("( 1 2 ) ( 3 4 ) unshift").run
      d.stack.inspect.should == "[((1, 2), 3, 4)]"
    end

    it "the Closure should be descriptive when printed" do
      d = DuckInterpreter.new("( 1 2 3 ) unshift").run
      d.stack.inspect.should == "[λ((1, 2, 3).unshift(?),[\"be\"])]"
    end

    it "should work with empty Lists" do
      d = DuckInterpreter.new("( ) ( ) unshift").run
      d.stack.inspect.should == "[(())]"
    end

    it "should work with nested Lists" do
      d = DuckInterpreter.new("( ( 1 ) 2 ) ( 3 ( 4 ) ) unshift").run
      d.stack.inspect.should == "[(((1), 2), 3, (4))]"
    end
  end
end
