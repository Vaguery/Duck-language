require_relative '../../spec_helper'


describe "DuckInterpreter" do
  describe "the :[] message for the Stack" do
    it "should be something the Interpreter recognizes" do
      DuckInterpreter.new.should respond_to(:[])
    end

    it "should produce a closure, looking for a number that responds to ++" do
      d = DuckInterpreter.new("[]").run
      d.stack[0].should be_a_kind_of(Closure)
    end

    it "should yank the nth element of the Stack to the top" do
      d = DuckInterpreter.new("1 2 3 4 5 2 []").run
      d.stack.inspect.should == "[1, 2, 4, 5, 3]"
    end

    it "should work with negative integers" do
      d = DuckInterpreter.new("1 2 3 4 5 -2 []").run
      d.stack.inspect.should == "[1, 2, 3, 5, 4]"
    end


    it "should work with large positive integers" do
      d = DuckInterpreter.new("1 2 3 4 5 12 []").run
      d.stack.inspect.should == "[1, 2, 4, 5, 3]"
    end


    it "should return the same object as the Stack originally contained (unlike List#[])" do
      d = DuckInterpreter.new("1 2 3 4 1").run
      old2 = d.stack[1].object_id
      d.script = "[]"
      d.run
      d.stack[-1].value.should == 2
      d.stack[-1].object_id.should == old2
      d.stack.inspect.should == "[1, 3, 4, 2]"
    end

    it "should not fail when the Stack is empty" do
      d = DuckInterpreter.new("3") # the number will get used up
      d.run
      d.script = "[]"
      d.run
      d.stack.inspect.should == "[]"
    end
  end
  
end