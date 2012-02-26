require_relative '../../spec_helper'

describe "Span" do
  describe "the :size message" do
    it "should be recognized" do
      Span.recognized_messages.should include(:size)
    end
    
    it "should return an array containing self and an Int" do
      Span.new(1,2).size.should be_a_kind_of(Array)
      Span.new(1,2).size[0].should be_a_kind_of(Span)
      Span.new(1,2).size[1].should be_a_kind_of(Int)
    end
    
    it "should be 2" do
      Span.new(3,1).size[1].value.should == 2
    end
  end
end
