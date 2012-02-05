require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":greedy" do
    it "should be possible to set the :greedy state with a message" do
      d = DuckInterpreter.new("greedy")
      d.greedy_flag = false
      d.run
      d.greedy_flag.should == true
    end
  end
end