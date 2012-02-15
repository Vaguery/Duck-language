require_relative '../../spec_helper'


describe "Int" do
  describe "the :copies message" do
    it "should be recognized by an Int" do
      Int.recognized_messages.should include(:copies)
    end

    it "should produce a Closure that wants one item that responds to :be" do
      d = interpreter(script:"2 copies").run
      d.contents[-1].should be_a_kind_of(Closure)
      d.contents[-1].needs.should == ["be"]
    end

    it "should create N copies of the next item it grabs" do
      d = interpreter(script:"5 copies 99").run
      d.contents.length.should == 5
      d.contents.inspect.should == "[99, 99, 99, 99, 99]"
    end

    it "should work for Int = 0" do
      d = interpreter(script:"0 copies 99").run
      d.contents.length.should == 0
      d.contents.inspect.should == "[]"
    end

    it "should do nothing for a negative Int" do
      d = interpreter(script:"-1 copies 99").run
      d.contents.length.should == 0
      d.contents.inspect.should == "[]"
    end

    it "should produce an Error if the total string representation is more than result_size_limit characters" do
      d = interpreter(script:"1000 copies foobarbaz")
      d.run
      d.contents.inspect.should == "[err:[OVERSIZED RESULT]]"
    end
  end
end
