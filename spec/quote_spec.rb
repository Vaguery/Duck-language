#encoding: utf-8
require_relative './spec_helper'



describe "the :quote message" do
  it "should be recognized by the interpreter" do
    DuckInterpreter.new.should respond_to(:quote)
  end
  
  it "should be recognized by a Script item"
  
  it "should create a Parser closure"
  
  it "should be recognized by an Int"
  
  it "should parse words from the source, and dump them into its destination (unstaged)"
  
  it "should dump what it's collected and move itself onto the stack when the script is empty"
end