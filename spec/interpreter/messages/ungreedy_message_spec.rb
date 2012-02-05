require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":ungreedy" do
    it "should be possible to unset the greedy state with a message" do
      d = DuckInterpreter.new("ungreedy")
      d.run
      d.greedy_flag.should == false
    end
  end
end