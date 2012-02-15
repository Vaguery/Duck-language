require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":ungreedy" do
    it "should be something Interpreters recognize" do
      Interpreter.recognized_messages.should include(:ungreedy)
    end
    
    it "should be possible to unset the greedy state with a message" do
      d = Interpreter.new
      d.ungreedy
      d.greedy_flag.should == false
    end
  end
end