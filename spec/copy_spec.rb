require_relative './spec_helper'
require 'timeout'

# NOTE do NOT try to refactor :copy into a message recognized by the copy message itself!

describe "the :copy message" do
  it "should be something the Interpreter recognizes" do
    Int.new.should_not respond_to(:copy)
    Bool.new.should_not respond_to(:copy)
    Bundle.new.should_not respond_to(:copy)
    DuckInterpreter.new.should respond_to(:copy)
  end
  
  it "should make return two copies of the top item" do
    d = DuckInterpreter.new("3 4 5 copy")
    d.run
    d.stack.inspect.should == "[3, 4, 5, 5]"
  end
  
  it "should not just replicate the pointer" do
    d = DuckInterpreter.new("3 4 5 copy")
    d.run
    d.stack[-1].object_id.should_not == d.stack[-2].object_id
  end
  
  it "should not time out on some weird loop when it encounters 'copy copy'" do
    d = DuckInterpreter.new("copy copy")
    lambda {Timeout::timeout(1) {d.run}}.should_not raise_error
  end
end