#encoding:utf-8
require_relative '../../spec_helper'

describe "Binder" do
  describe "the :size message" do
    it "should be recognized" do
      Binder.recognized_messages.should include(:size)
    end
    
    it "should be 1 for an empty Binder" do
      Binder.new.size[1].value.should == 1
    end
    
    it "should be a total of the #size results from all its contents, plus itself" do
      tree = list([list([int(1)]), assembler(contents:[int(8)])])
      line = list([int(1), int(2), int(3)])
      Binder.new([tree, line]).size[1].value.should ==
        1 + tree.size[1].value + line.size[1].value
    end
    
    it "will get complicated when a Binder is sent the :size message in a script, though..." do
      interpreter(script:"size", contents:[Binder.new([int(1), int(2)])]).run.inspect.should ==
        "[{1, 2}, 2, 1 :: :: «»]"
    end # because the Binder is actually providing the '2', and THAT is responding to :size
  end
end
