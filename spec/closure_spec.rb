#encoding: utf-8
require_relative './spec_helper'

describe "initialization" do
  it "should have a #closure attribute, which is a Proc" do
    Closure.new(Proc.new {:foo},[]).closure.call.should == :foo
  end
  
  it "should have an array of #needs" do
    Closure.new(Proc.new {:foo},["bar"]).needs.should == ["bar"]
  end
end