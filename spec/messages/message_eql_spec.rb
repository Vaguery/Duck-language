require_relative '../spec_helper'

describe "Messages responding to :eql" do
  it "should create a Closure looking for a second Message" do
    m = Message.new("foo").eql
    m.should be_a_kind_of(Closure)
    m.needs.should == ["do"]
  end
  
  it "should create a F Bool if the two message have different values" do
    d = DuckInterpreter.new("foo bar eql").run
    d.stack.inspect.should == "[F]"
  end
  
  it "should create a T Bool if the two message have identical values" do
    d = DuckInterpreter.new("foo foo eql").run
    d.stack.inspect.should == "[T]"
  end
end