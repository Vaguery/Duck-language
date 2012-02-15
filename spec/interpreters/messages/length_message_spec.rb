require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :length message" do
    it "should be a message recognized by Interpreters" do
      Interpreter.recognized_messages.should include(:length)
    end
    
    it "should return an Int item" do
      Interpreter.new.length.should be_a_kind_of(Int)
      interpreter(contents:[int(4)]*12).length.value.should == 12
    end
    
    
    it "should work for empty stacks" do
      Interpreter.new.length.value.should == 0
    end
  end
end
