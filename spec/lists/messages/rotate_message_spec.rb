require_relative '../../spec_helper'

describe "List" do
  describe "the :rotate message for Lists" do
    it "should be something a List recognizes" do
      List.recognized_messages.should include(:rotate)
    end

    it "should rotate the contents of the List" do
      d = interpreter(script:"( 1 2 3 4 5 ) rotate").run
      d.contents.inspect.should == "[(2, 3, 4, 5, 1)]"
    end

    it "should work for an empty List" do
      d = interpreter(script:"( ) rotate").run
      d.contents.inspect.should == "[()]"
    end
  end
end


