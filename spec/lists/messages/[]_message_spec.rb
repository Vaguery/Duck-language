require_relative '../../spec_helper'

describe "List" do
  describe "the :[] message for Lists" do
    it "should be something Lists recognize" do
      List.new.should respond_to(:[])
    end

    it "should produce a closure, looking for a number that responds to ++" do
      List.new.[].should be_a_kind_of(Closure)
      List.new.[].needs.should == ["inc"]
    end

    it "should return the nth element of the List" do
      d = DuckInterpreter.new("( 1 2 3 4 ) [] 2").run
      d.stack.inspect.should == "[3]"
    end

    it "should work with negative integers" do
      d = DuckInterpreter.new("( 1 2 3 4 ) [] -12").run
      d.stack.inspect.should == "[1]"
    end

    it "should work with large positive integers" do
      d = DuckInterpreter.new("( 1 2 3 4 ) [] 30").run
      d.stack.inspect.should == "[3]"
    end

    it "should work with an empty List" do
      d = DuckInterpreter.new("( ) [] 1").run
      d.stack.inspect.should == "[]"
    end

    it "should not return the same object as the List contained" do
      d = DuckInterpreter.new("( 1 2 3 4 )").run
      d.stack[0].should be_a_kind_of(List)
      old_three_id = d.stack[0].contents[2].object_id
      d.script = "[] 2"
      d.run
      d.stack.inspect.should == "[3]"
      new_three_id = d.stack[0].object_id
      new_three_id.should_not == old_three_id
    end
  end
end
