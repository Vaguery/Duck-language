require_relative '../../spec_helper'

describe "List" do
  describe "the :flatten message for Lists" do
    it "should be recognized by Lists" do
      List.recognized_messages.should include(:flatten)
    end

    it "should produce a List as a result" do
      List.new.flatten.should be_a_kind_of(List)
    end

    it "should shatter Lists that appear inside the receiving List" do
      d = interpreter(script:"( ( 1 2 ) ( 3 ) ( 4 ) ) 5 flatten").run
      d.contents.inspect.should == "[5, (1, 2, 3, 4)]"
    end

    it "should not affect nested Lists (behaving like Array#flatten(1))" do
      d = interpreter(script:"( 1 2 ( 3 ( 4 ) ) ) 5 flatten").run
      d.contents.inspect.should == "[5, (1, 2, 3, (4))]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) 5 flatten").run
      d.contents.inspect.should == "[5, ()]"
    end
  end
end
