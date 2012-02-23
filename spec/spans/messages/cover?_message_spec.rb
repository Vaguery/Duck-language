#encoding: utf-8
require_relative '../../spec_helper'

describe "Span" do
  describe "the :cover? message" do
    it "should be something a Span recognizes" do
      Span.recognized_messages.should include(:cover?)
    end

    it "should produce a closure looking for another Span" do
      grabby = Span.new(1,2).cover?
      grabby.should be_a_kind_of(Closure)
      grabby.needs.should == ["cover?"]
    end
    
    it "should return a Bool indicating the second arg is ENTIRELY within the first Span" do
      a = Span.new(1,10)
      b = Span.new(2,9)
      interpreter(script:"cover?", contents:[b,a]).run.inspect.should == "[T :: :: «»]"
      
      a = Span.new(1,10)
      b = Span.new(9,2)
      interpreter(script:"cover?", contents:[b,a]).run.inspect.should == "[T :: :: «»]"
      
      a = Span.new(1,10)
      b = Span.new(9,11)
      interpreter(script:"cover?", contents:[b,a]).run.inspect.should == "[F :: :: «»]"
      
      a = Span.new(1,10)
      b = Span.new(-12.1,22.2)
      interpreter(script:"cover?", contents:[b,a]).run.inspect.should == "[F :: :: «»]"
      
      a = Span.new(1,10)
      b = Span.new(-12.1,22.2)
      interpreter(script:"cover?", contents:[a,b]).run.inspect.should == "[T :: :: «»]"
    end
  end
end
