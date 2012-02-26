require_relative '../../spec_helper'

describe "Assembler" do
  describe "the :size message" do
    it "should be recognized" do
      Assembler.recognized_messages.should include(:size)
    end
    
    it "should be 1 for an empty Assembler" do
      Assembler.new.size[1].value.should == 1
    end
    
    it "should be a total of the #size results from all its contents AND buffer items, plus itself" do
      tree = list([list([int(1)]), assembler(contents:[int(8)])]) #
      line = list([int(1), int(2), int(3)])
      assembler(contents:[line], buffer:[tree]).size[1].value.should == 
        tree.size[1].value + line.size[1].value + 1
    end
  end
end
