#encoding:utf-8
require_relative '../spec_helper'

describe "Variable class" do
  describe "initialization" do
    it "takes a string (its @key) and any other item" do
      b = Variable.new("foo", int(9))
      b.key.should == :foo
      b.value.value.should == 9
    end
    
    it "should have a Duck shortcut" do
      variable("x", bool(T)).inspect.should == ":x=T"
    end
    
    
    it "should have no needs" do
      variable("foo", int(9)).needs.should == []
    end
    
    it "should raise an error if it's created with a key that's not a Symbol or String" do
      lambda{ variable(12, int(0)) }.should raise_error(ArgumentError)
    end
    
    it "should raise an error if it's created with a value that's not a Duck::Item" do
      lambda{ variable(:x, [int(0)]) }.should raise_error(ArgumentError)
    end
    
  end
  
  describe "response" do
    it "should recognize its key as a Message" do
      b = variable("foo", int(9))
      b.recognize_message?("foo").should == true
    end
    
    it "should return both itself and its value(s)" do
      b = variable("foo", int(9))
      result = b.foo
      result.should be_a_kind_of(Array)
      result[0].should == b
      result[1].value.should == 9
    end
    
    
    it "should return a deep_copy of its value in response" do
      b = variable("foo", int(9))
      result = b.foo
      result[1].should be_a_kind_of(Int)
      result[1].object_id.should_not == b.value.object_id
    end
  end
  
  describe "visualization" do
    it "should include the key and value" do
      variable("foo", decimal(123.456)).to_s.should == ":foo=123.456"
    end
  end
end