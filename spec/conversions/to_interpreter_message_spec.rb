#encoding: utf-8
require_relative '../spec_helper'

describe "the :to_interpreter message" do
  describe "the Binder class" do
    it "should be recognized by Binder items" do
      Binder.recognized_messages.should include(:to_interpreter)
    end
    
    it "should produce an Interpreter item" do
      Binder.new([int(121)]).to_interpreter.inspect.should == "[121 :: :: «»]"
    end
  end
  
  describe "the Assembler class" do
    it "should be recognized by Assembler items" do
      Assembler.recognized_messages.should include(:to_interpreter)
    end
    
    it "should produce an Interpreter item from the contents" do
      assembler(contents:[bool(F)]).to_interpreter.inspect.should == "[F :: :: «»]"
    end
    
    it "should include the buffer" do
      assembler(contents:[bool(F)], buffer:[int(111)]).to_interpreter.inspect.should ==
        "[F :: 111 :: «»]"
    end
  end
  
  describe "the List class" do
    it "should be recognized by List items" do
      List.recognized_messages.should include(:to_interpreter)
    end
    
    it "should produce an Interpreter item from the contents" do
      list([bool(F), Binder.new()]).to_interpreter.inspect.should == "[F, {} :: :: «»]"
    end
  end
end