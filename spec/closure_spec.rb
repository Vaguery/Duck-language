#encoding: utf-8
require_relative './spec_helper'

describe "initialization" do
  it "should have an actor attribute" do
    Closure.new(Int.new(12),"+",[],[]).actor.value.should == 12
  end
  
  it "should have a method attribute" do
    Closure.new(Int.new(12),"+",[],[]).method.should == "+"
  end
  
  it "should have an args attribute" do
    Closure.new(Int.new(12),"+",[Int.new(2)],[]).args[0].value.should == 2
  end
  
  it "should have a needs attribute" do
    Closure.new(Int.new(12),"+",[],["+"]).needs[0].should == "+"
  end
end