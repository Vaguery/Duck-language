#encoding: utf-8
require_relative '../../spec_helper'

# [for cutting and pasting: ¬ ∧ ∨ ]
describe "Bool" do
  describe "∨" do
    it "should be recognized by Bool items to produce a Closure" do
      d = DuckInterpreter.new("∨ F").run
      d.stack[-1].needs.should == ["¬"]
    end

    it "should have a legible Closure representation" do
      d = DuckInterpreter.new("∨ F").run
      d.stack[-1].to_s.should == 'λ(false ∨ ?,["¬"])'
    end

    it "should produce the appropriate Bool value" do
      d = DuckInterpreter.new("T T ∨").run
      d.stack[-1].value.should == true

      d = DuckInterpreter.new("T F ∨").run
      d.stack[-1].value.should == true

      d = DuckInterpreter.new("F T ∨").run
      d.stack[-1].value.should == true

      d = DuckInterpreter.new("F F ∨").run
      d.stack[-1].value.should == false
    end
  end
end
