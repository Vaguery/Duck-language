require_relative '../../spec_helper'

describe "Collector" do
  describe "the :size message" do
    it "should be recognized" do
      Collector.recognized_messages.should include(:size)
    end
    
    it "should be 1 for an empty Collector" do
      Collector.new.size[1].value.should == 1
    end
    
    it "should be a total of the #size results from all its contents items, plus itself" do
      tree = list([list([int(1)]), assembler(contents:[int(8)])]) #
      line = list([int(1), int(2), int(3)])
      foo = Collector.new(5)
      foo.contents << tree
      foo.contents << line
      foo.size[1].value.should == 
        tree.size[1].value + line.size[1].value + 1
    end
  end
end
