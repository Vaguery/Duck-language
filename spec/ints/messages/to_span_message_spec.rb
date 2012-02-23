#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "to_span" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include :to_span
    end
    
    it "should return a Closure" do
      int(8).to_span.should be_a_kind_of(Closure)
    end
    
    it "should produce a Span item" do
      interpreter(script:"8 11 to_span").run.inspect.should == "[(11..8) :: :: «»]"
    end
  end
end
