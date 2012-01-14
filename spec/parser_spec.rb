#encoding: utf-8
require_relative './spec_helper'

describe "parse next word" do
  before(:each) do
    @ducky = DuckInterpreter.new("123 -912 4.56 -67.8 false foo +")
  end
  
  it "should recognize the next word of script" do
    @ducky.should_receive(:recognize).with("123")
    @ducky.parse
  end
  
  it "should append the result of parsing to the queue" do
    @ducky.queue += ["foo"]
    @ducky.queue.length.should == 1
    @ducky.parse
    @ducky.queue.length.should == 2
  end
  
  it "should shorten the script by one token" do
    @ducky.parse
    @ducky.script.should == "-912 4.56 -67.8 false foo +"
  end
  
  describe "integers" do
    it "should recognize integers" do
      @ducky.parse
      @ducky.queue[-1].value.should == 123
    end
    
    it "should handle negative integers" do
      @ducky.parse.parse
      @ducky.queue[-1].value.should == -912
    end
  end
  
  
  describe "messages" do
    it "should create a Closure looking for a recipient when it encounters a message" do
      no_numbers = DuckInterpreter.new("+ - foo")
      no_numbers.parse.queue[-1].needs.should include("+")
      no_numbers.parse.queue[-1].needs.should include("-")
      no_numbers.parse.queue[-1].needs.should include("foo")
    end
  end
  
  it "should turn gibberish into a message" do
    DuckInterpreter.new("::«91__\\»\" :foo").parse.queue[-1].value == "::«91__\\»\""
  end
end