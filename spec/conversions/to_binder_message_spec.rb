#encoding: utf-8
require_relative '../spec_helper'

describe "the :to_binder message" do
  describe "the Assembler class" do
    it "should be recognized by Assembler items" do
      Assembler.recognized_messages.should include(:to_binder)
    end
    
    it "should produce a Binder item" do
      assembler(contents:[int(121)]).to_binder.inspect.should == "{121}"
    end
    
    it "should include the buffer" do
      assembler(contents:[int(121)], buffer:[bool(F)]).to_binder.inspect.should == "{121, F}"
    end
  end
  
  describe "the Interpreter class" do
    it "should be recognized by Interpreter items" do
      Interpreter.recognized_messages.should include(:to_binder)
    end
    
    it "should include the script, even if it's empty" do
      Interpreter.new.to_binder.inspect.should == "{«»}"
      interpreter(script:"foo bar").to_binder.inspect.should == "{«foo bar»}"
    end
    
    it "should produce a Binder item from the contents" do
      interpreter(script:"foo",contents:[bool(F)]).to_binder.inspect.should == "{«foo», F}"
    end
    
    it "should include the buffer" do
      interpreter(script:"+ 1 2",contents:[bool(F)], buffer:[int(111)]).to_binder.inspect.should ==
        "{«+ 1 2», F, 111}"
    end
  end
  
  describe "the List class" do
    it "should be recognized by List items" do
      List.recognized_messages.should include(:to_binder)
    end
    
    it "should produce a Binder item from the contents" do
      list([bool(F), Binder.new()]).to_binder.inspect.should == "{F, {}}"
    end
  end
end