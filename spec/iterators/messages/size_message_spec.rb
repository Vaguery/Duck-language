require_relative '../../spec_helper'

describe "Iterator" do
  describe "the :size message" do
    it "should be recognized" do
      Iterator.recognized_messages.should include(:size)
    end
    
    
    it "should act like a List would, counting the contents, adding one more for the span" do
      con = [int(1), int(2), list([int(3)])]
      Iterator.new(start:1, end:9, contents:con).size[1].value.should == 6
    end
  end
end
