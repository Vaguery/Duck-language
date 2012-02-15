require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":greedy" do
    it "should be a thing Interpreters recognize" do
      Interpreter.recognized_messages.should include(:greedy)
    end
    
    it "should be possible to set the :greedy state with a message" do
      d = Interpreter.new
      d.greedy_flag = false
      d.greedy
      d.greedy_flag.should == true
    end
  end
end