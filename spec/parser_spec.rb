#encoding: utf-8
require_relative './spec_helper'

describe "grab next word" do
  before(:each) do
    @ducky = DuckInterpreter.new("123 4.56 false foo +")
  end
  
  it "should grab the next word of script" do
    @ducky.parse
    @ducky.queue[-1].should == "123"
  end
  
  it "should shorten the script" do
    @ducky.parse
    @ducky.script.should == "4.56 false foo +"
  end
  
  it "should work with whatever gibberish there is in the word" do
    DuckInterpreter.new("::«91__\\»\" :foo").parse.queue[-1].should == "::«91__\\»\""
  end
end