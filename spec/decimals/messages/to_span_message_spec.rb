#encoding: utf-8
require_relative '../../spec_helper'

describe "Decimal" do
  describe "to_span" do
    it "should be recognized by Decimal items" do
      Decimal.recognized_messages.should include :to_span
    end
    
    it "should return a Closure" do
      decimal(8.9).to_span.should be_a_kind_of(Closure)
    end
    
    it "should produce a Span item" do
      interpreter(script:"-1.1 2.2 to_span").run.inspect.should == "[(2.2..-1.1) :: :: «»]"
    end
  end
end
