require_relative './spec_helper'

describe "the :copies message" do
  it "should be recognized by an Int" do
    Int.new.should respond_to(:copies)
  end
  
  it "should produce a Closure that wants one item that responds to :be" do
    d = DuckInterpreter.new("2 copies").run
    d.stack[-1].should be_a_kind_of(Closure)
    d.stack[-1].needs.should == ["be"]
  end
  
  it "should create N copies of the next item it grabs" do
    d = DuckInterpreter.new("5 copies 99").run
    d.stack.length.should == 5
    d.stack.inspect.should == "[99, 99, 99, 99, 99]"
  end
  
  it "should work for Int = 0" do
    d = DuckInterpreter.new("0 copies 99").run
    d.stack.length.should == 0
    d.stack.inspect.should == "[]"
  end
  
  it "should do nothing for a negative Int" do
    d = DuckInterpreter.new("-1 copies 99").run
    d.stack.length.should == 0
    d.stack.inspect.should == "[]"
  end
end