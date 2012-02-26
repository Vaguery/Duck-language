require_relative '../../spec_helper'

describe "Pipe" do
  describe "the :size message" do
    it "should be recognized" do
      Pipe.recognized_messages.should include(:size)
    end
    
    it "should return an array containing self and an Int" do
      Pipe.new.size.should be_a_kind_of(Array)
      Pipe.new.size[0].should be_a_kind_of(Pipe)
      Pipe.new.size[1].should be_a_kind_of(Int)
    end
    
    it "should be 1 for an empty Pipe" do
      Pipe.new.size[1].value.should == 1
    end
    
    it "should be a total of the #size results from all its contents, plus itself" do
      tree_like = list([list([int(1)]), assembler(contents:[int(8)])])
      Pipe.new([tree_like]).size[1].value.should == 6
    end
  end
end
