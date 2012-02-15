require_relative '../../spec_helper'

describe "List" do
  describe "the :snap message for Lists" do
    it "should be recognized by Lists" do
      List.recognized_messages.should include(:snap)
    end

    it "should produce a Closure looking for an Int as a result" do
      List.new.snap.should be_a_kind_of(Closure)
      List.new.snap.needs.should == ["inc"]
    end

    it "should break the List into two parts, at the location indicated by the Int" do
      d = interpreter(script:"( 1 2 3 4 5 ) 2 snap").run
      d.contents.inspect.should == "[(1, 2), (3, 4, 5)]"

      d = interpreter(script:"( 33 ) 0 snap").run
      d.contents.inspect.should == "[(), (33)]"
    end

    it "should work with negative Ints" do
      d = interpreter(script:"( 1 2 3 4 5 ) -1 snap").run
      d.contents.inspect.should == "[(1, 2, 3, 4), (5)]"
    end

    it "should work with large positive and negative Ints modulo the number of items" do
      d = interpreter(script:"( 1 2 3 4 5 ) -11 snap").run
      d.contents.inspect.should == "[(1, 2, 3, 4), (5)]"

      d = interpreter(script:"( 1 2 3 4 5 ) 11 snap").run
      d.contents.inspect.should == "[(1), (2, 3, 4, 5)]"
    end

    it "should work when the Int is 0" do
      d = interpreter(script:"( 1 2 3 4 5 ) 0 snap").run
      d.contents.inspect.should == "[(), (1, 2, 3, 4, 5)]"
    end

    it "should work with empty Lists" do
      d = interpreter(script:"( ) 5 snap").run
      d.contents.inspect.should == "[()]"
    end
  end
end
