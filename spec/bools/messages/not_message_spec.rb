#encoding: utf-8
require_relative '../../spec_helper'

# [for cutting and pasting: ¬ ∧ ∨ ]
describe "Bool" do
  describe "¬ message" do
    it "should be recognized by Bool items" do
      d = interpreter(script:"¬").run
      d.contents[-1].needs.should == ["¬"]
    end

    it "should produce the opposite boolean value" do
      d = interpreter(script:"false ¬").run
      d.contents[-1].value.should == true
    end
  end
end
