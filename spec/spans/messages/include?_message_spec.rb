#encoding: utf-8
require_relative '../../spec_helper'

describe "Span" do
  describe ":include? message" do
    it "should be recognized by Span items" do
      Span.recognized_messages.should include :include?
    end
    
    
    it "should return a Closure looking for a Number" do
      c = Span.new(8,2).include?
      c.should be_a_kind_of(Closure)
      c.needs.should == ["neg"]
    end
    
    it "should return a Bool indicating whether the number falls inside the range" do
      interpreter(script:"2 include?", contents:[Span.new(3,6)]).run.inspect.should ==
        "[F :: :: «»]"
      interpreter(script:"2.3 include?", contents:[Span.new(1.3,6.9)]).run.inspect.should ==
        "[T :: :: «»]"
      interpreter(script:"2.3 include?", contents:[Span.new(2.3,6.9)]).run.inspect.should ==
        "[T :: :: «»]"
    end
  end
end
