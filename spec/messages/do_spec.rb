require_relative '../spec_helper'

describe "the :do message" do
  it "should be recognized by a Message object" do
    d = DuckInterpreter.new("3 F + foo")
    d.run
    d.stack.each do |item|
      item.should_not respond_to(:do) unless item.kind_of?(Message)
      item.should respond_to(:do) if item.kind_of?(Message)
    end
  end
  
  it "should re-stage the Message" do
    d = DuckInterpreter.new("foo 1 2 3 4 5 do")
    d.run
    d.stack[-1].value.should == :foo
  end
end