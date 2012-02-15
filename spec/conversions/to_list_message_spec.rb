#encoding: utf-8
require_relative '../spec_helper'

describe "the :to_list message" do
  describe "the Assembler class" do
    it "should be recognized by Assembler items" do
      Assembler.recognized_messages.should include(:to_list)
    end
    
    it "should produce a List item" do
      assembler(contents:[int(121)]).to_list.inspect.should == "(121)"
    end
    
    it "should include the buffer" do
      assembler(contents:[int(121)], buffer:[bool(F)]).to_list.inspect.should == "(121, F)"
    end
  end
  
  describe "the Interpreter class" do
    it "should be recognized by Interpreter items" do
      Interpreter.recognized_messages.should include(:to_list)
    end
    
    it "should include the script, even if it's empty" do
      Interpreter.new.to_list.inspect.should == "(«»)"
      interpreter(script:"foo bar").to_list.inspect.should == "(«foo bar»)"
    end
    
    
    it "should produce a List item from the contents" do
      interpreter(script:"",contents:[bool(F)]).to_list.inspect.should == "(«», F)"
    end
    
    it "should include the buffer" do
      interpreter(script:"+ 1 2",contents:[bool(F)], buffer:[int(111)]).to_list.inspect.should == "(«+ 1 2», F, 111)"
    end
  end
  
  describe "the Binder class" do
    it "should be recognized by Binder items" do
      Binder.recognized_messages.should include(:to_list)
    end
    
    it "should produce a List item from the contents" do
      Binder.new([bool(F), Binder.new()]).to_list.inspect.should == "(F, {})"
    end
  end
end