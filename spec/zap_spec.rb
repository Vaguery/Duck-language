require_relative './spec_helper'

describe ":zap message" do
  it "should be recognized by Closures" do
    Closure.new(Proc.new {:foo},[],"").should respond_to(:zap)
  end
  
  it "should delete the closure" do
    d = DuckInterpreter.new("3 +").run
    d.stack[-1].should be_a_kind_of(Closure)
    d.script = "zap"
    d.run
    d.stack.inspect.should == "[]"
  end
  
  it "should work for Messages too" do
    d = DuckInterpreter.new("+ - *").run
    d.stack[-1].should be_a_kind_of(Message)
    d.script = "zap"
    d.run
    d.stack.inspect.should == "[:+, :-]"
  end
end