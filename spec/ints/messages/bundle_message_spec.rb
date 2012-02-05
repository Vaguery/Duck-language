#encoding:utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "the :bundle message" do
    it "should be recognized by Ints" do
      Int.new(8).should respond_to(:bundle)
    end

    it "should produce a Collector gathering N items responding to :be" do
      Int.new(3).bundle.needs.should == ["be"]
    end

    it "should produce a List when it's done gathering items" do
      d = DuckInterpreter.new("3 bundle a b c d").run
      d.stack.inspect.should == "[(:a, :b, :c), :d]"
    end

    it "should produce an empty List if the integer is negative or 0" do
      d = DuckInterpreter.new("-3 bundle foo 0 bundle bar").run
      d.stack.inspect.should == "[(), :foo, (), :bar]"
    end

    it "should complete even if no subsequent item appears" do
      d = DuckInterpreter.new("2 bundle 3 4").run
      d.stack.inspect.should == "[(3, 4)]"
    end
  end
end
