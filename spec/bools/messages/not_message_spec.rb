#encoding: utf-8
require_relative '../../spec_helper'

# [for cutting and pasting: ¬ ∧ ∨ ]
describe "Bool" do
  describe "¬ message" do
    it "should be recognized by Bool items" do
      d = DuckInterpreter.new("¬").step
      d.stack[-1].needs.should == ["¬"]
    end

    it "should produce the opposite boolean value" do
      d = DuckInterpreter.new("false ¬").run
      d.stack[-1].value.should == true
    end
  end
end
