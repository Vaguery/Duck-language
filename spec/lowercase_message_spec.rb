#encoding:utf-8
require_relative './spec_helper'

describe "the :lowercase message" do
  it "should be recognized by a Script item" do
    Script.recognized_messages.should include(:lowercase)
  end
  
  it "should produce a new Script with the value downcased" do
    lc = Script.new("Foo BAR").lowercase
    lc.value.should == "foo bar"
  end
end