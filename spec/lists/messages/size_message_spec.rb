require_relative '../../spec_helper'

describe "List" do
  describe "the :size message" do
    it "should be recognized" do
      List.recognized_messages.should include(:size)
    end
    
    it "should return an array containing self and an Int" do
      List.new.size.should be_a_kind_of(Array)
      List.new.size[0].should be_a_kind_of(List)
      List.new.size[1].should be_a_kind_of(Int)
    end
    
    it "should be 1 for an empty List" do
      List.new.size[1].value.should == 1
    end
    
    it "should be a count of the number of items in a flat list, plus 1 for the list itself" do
      list([int(1), int(2), int(3)]).size[1].value.should == 4
    end
    
    it "should be a total of the #size results from all its contents, plus itself" do
      tree_like = list([list([int(1)]), assembler(contents:[int(8)])])
      tree_like.size[1].value.should == 5
    end
  end
end
