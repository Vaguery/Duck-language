#encoding: utf-8
require_relative '../../spec_helper'

# [for cutting and pasting: ¬ ∧ ∨ ]
describe "Bool" do
  describe "∨" do
    it "should be recognized by Bool items to produce a Closure" do
      d = interpreter(script:"∨ F").run
      d.contents[-1].needs.should == ["¬"]
    end

    it "should have a legible Closure representation" do
      d = interpreter(script:"∨ F").run
      d.contents[-1].to_s.should == 'λ(false ∨ ?,["¬"])'
    end

    it "should produce the appropriate Bool value" do
      d = interpreter(script:"T T ∨").run
      d.contents[-1].value.should == true

      d = interpreter(script:"T F ∨").run
      d.contents[-1].value.should == true

      d = interpreter(script:"F T ∨").run
      d.contents[-1].value.should == true

      d = interpreter(script:"F F ∨").run
      d.contents[-1].value.should == false
    end
  end
end
