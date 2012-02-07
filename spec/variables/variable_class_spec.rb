#encoding:utf-8
require_relative '../spec_helper'

describe "Variable class" do
  describe "initialization" do
    it "takes a string (its @key) and any other item" do
      b = Variable.new("foo", Int.new(9))
      b.key.should == :foo
      b.value.value.should == 9
    end
    
    it "should have no needs" do
      Variable.new("foo", Int.new(9)).needs.should == []
    end
  end
  
  describe "response" do
    it "should recognize its key as a Message" do
      b = Variable.new("foo", Int.new(9))
      b.recognize_message?("foo").should == true
    end
    
    it "should return two items (at least): itself, and its value(s)" do
      b = Variable.new("foo", Int.new(9))
      b.foo[0].should == b
      b.foo[1].should be_a_kind_of(Int)
    end
    
    
    it "should return a deep_copy of its value in response" do
      b = Variable.new("foo", Int.new(9))
      result = b.foo[1]
      result.should be_a_kind_of(Int)
      result.object_id.should_not == b.value.object_id
    end
  end
  
  describe "visualization" do
    it "should include the key and value" do
      Variable.new("foo", Decimal.new(123.456)).to_s.should == ":foo=123.456"
    end
  end
end