#encoding:utf-8
require_relative '../spec_helper'

describe "the Span class" do
  describe "initialization" do
    it "should be possible to create one using two integers" do
      ns = Span.new(1,2)
      ns.start_value.should == 1
      ns.end_value.should == 2
    end
    
    it "should be possible to create one using two floats" do
      ns = Span.new(1.2,3.4)
      ns.start_value.should == 1.2
      ns.end_value.should == 3.4
    end
  end
  
  describe "visualization" do
    it "should look like a Ruby Range" do
      Span.new(-121, 33).inspect.should == "(-121..33)"
      Span.new(-3.2, -99.1).inspect.should == "(-3.2..-99.1)"
    end
  end
end