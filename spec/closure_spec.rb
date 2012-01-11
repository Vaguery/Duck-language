#encoding: utf-8
require_relative './spec_helper'

describe "initialization" do
  it "should have an actor attribute" do
    ClosureItem.new(IntegerItem.new(12),"+",[],[]).actor.value.should == 12
  end
  
  it "should have a method attribute" do
    ClosureItem.new(IntegerItem.new(12),"+",[],[]).method.should == "+"
  end
  
  it "should have an args attribute" do
    ClosureItem.new(IntegerItem.new(12),"+",[IntegerItem.new(2)],[]).args[0].value.should == 2
  end
  
  it "should have a needs attribute" do
    ClosureItem.new(IntegerItem.new(12),"+",[],["+"]).needs[0].should == "+"
  end
end