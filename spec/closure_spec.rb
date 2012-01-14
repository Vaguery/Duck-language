#encoding: utf-8
require_relative './spec_helper'

describe "initialization" do
  it "should have a #closure attribute, which is a Proc" do
    Closure.new(Proc.new {:foo},[]).closure.call.should == :foo
  end
  
  it "should have an array of #needs" do
    Closure.new(Proc.new {:foo},["bar"]).needs.should == ["bar"]
  end
  
  it "should accept an optional #string_value" do
    Closure.new(Proc.new {:foo},["bar"],"HI THERE").string_version.should == "HI THERE"
  end
end


describe "value" do
  it "should be the string representation" do
    c = Closure.new(Proc.new {|a,b,c,d| (a+b).collect(c).filter(d)},["foo","bar","bar","baz"])
    c.value.should == c.to_s
  end
end


describe "string representation" do
  before(:each) do
    @simple = Closure.new(Proc.new {|a| a},["bar"])
    @complicated = Closure.new(Proc.new {|a,b,c,d| (a+b).collect(c).filter(d)},["foo","bar","bar","baz"])
  end
  
  it "should say it's a closure" do
    @simple.to_s.should =~ /closure\(.*\)/
    @complicated.to_s.should =~ /closure\(.*\)/
  end
  
  it "should say what it needs" do
    @simple.to_s.should =~ /"bar"/
    @complicated.to_s.should =~ /"foo",\s*"bar",\s*"bar",\s*"baz"/
  end
  
  it "should default to saying something about the number of args in the Proc" do
    Closure.new(Proc.new {|a| a},["bar"]).to_s.should =~
      /f\(\*\)/
  end
  
  it "should be able to show something to indicate the method call" do
    annotated = Closure.new(Proc.new {|a,b| a+2*b},["bar","baz"],"arg1 + 2*arg2")
    annotated.to_s.should include "arg1 + 2*arg2"
  end
end