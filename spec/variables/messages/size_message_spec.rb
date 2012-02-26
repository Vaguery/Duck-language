require_relative '../../spec_helper'

describe "Variable" do
  describe "the :size message" do
    it "should be recognized" do
      Variable.recognized_messages.should include(:size)
    end
    
    it "should return an array containing self and an Int" do
      Variable.new(:f,int(6)).size.should be_a_kind_of(Array)
      Variable.new(:f,int(6)).size[0].should be_a_kind_of(Variable)
      Variable.new(:f,int(6)).size[1].should be_a_kind_of(Int)
    end
    
    it "should be 2 + the size of the value" do
      Variable.new(:f,int(4)).size[1].value.should == 2 + int(4).size[1].value
      Variable.new(:f,list([int(4), int(5)])).size[1].value.should == 5
    end
  end
end
