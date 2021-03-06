#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "to_list" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :to_list
    end
    
    it "should return the Span AND the contents" do
      makes_numbers = Iterator.new(start:3, end:5, contents:(0..11).collect {|i| int(i)})
      makes_numbers.to_list.inspect.should == "((3..5), 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11)"
    end
  end
end
