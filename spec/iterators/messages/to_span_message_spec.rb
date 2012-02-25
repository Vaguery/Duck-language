#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe ":to_span message" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :to_span
    end
    
    
    it "should return a Span with the @start and @end values of the Iterator" do
      s = Iterator.new(start:12, end:-9).to_span
      s.start_value.should == 12
      s.end_value.should == -9
      
      s = Iterator.new.to_span
      s.start_value.should == 0
      s.end_value.should == 0
    end
  end
end
