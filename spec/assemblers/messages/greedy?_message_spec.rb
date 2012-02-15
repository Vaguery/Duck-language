require_relative '../../spec_helper'

describe "Assembler" do
  describe ":greedy?" do
    it "should be recognized" do
      Assembler.recognized_messages.should include(:greedy?)
    end
    
    it "should return a Bool Item than has the correct value" do
      d = Assembler.new
      d.greedy?.should be_a_kind_of(Bool)
      d.greedy?.value.should == true
      d.ungreedy
      d.greedy?.value.should == false
    end
  end
end