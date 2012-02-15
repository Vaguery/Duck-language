require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":greedy?" do
    it "should be recognized" do
      Interpreter.recognized_messages.should include(:greedy?)
    end
    
    it "should respond with a Bool" do
      i = Interpreter.new
      i.greedy?.should be_a_kind_of(Bool)
      i.greedy?.value.should == true
      i.ungreedy
      i.greedy?.value.should == false
    end
  end
end