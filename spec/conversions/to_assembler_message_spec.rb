#encoding: utf-8
require_relative '../spec_helper'

describe "the :to_assembler message" do
  describe "the Binder class" do
    it "should be recognized by Binder items" do
      Binder.recognized_messages.should include(:to_assembler)
    end
    
    it "should produce an Assembler item" do
      Binder.new([int(121)]).to_assembler.inspect.should == "[121 ::]"
    end
  end
  
  describe "the Interpreter class" do
    it "should be recognized by Interpreter items" do
      Interpreter.recognized_messages.should include(:to_assembler)
    end
    
    it "should include the script, even if it's empty" do
      Interpreter.new.to_assembler.inspect.should == "[«» ::]"
      interpreter(script:"foo bar").to_assembler.inspect.should == "[«foo bar» ::]"
    end
    
    it "should produce an Assembler item from the contents" do
      interpreter(script:"foo",contents:[bool(F)]).to_assembler.inspect.should == "[«foo», F ::]"
    end
    
    it "should include the buffer" do
      interpreter(script:"+ 1 2",contents:[bool(F)],
        buffer:[int(111)]).to_assembler.inspect.should ==
        "[«+ 1 2», F :: 111]"
    end
  end
  
  describe "the List class" do
    it "should be recognized by List items" do
      List.recognized_messages.should include(:to_assembler)
    end
    
    it "should produce an Assembler item from the contents" do
      list([bool(F), Binder.new()]).to_assembler.inspect.should == "[F, {} ::]"
    end
  end
end