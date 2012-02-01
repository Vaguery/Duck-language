#encoding: utf-8
require_relative './spec_helper'

describe "oversized results" do
  it "should prohibit more than Item.result_size_limit character results (as inspected strings)" do
    d = DuckInterpreter.new("1000 copies foobar")
    d.run.stack.inspect.should == "[err:OVERSIZED RESULT]"
  end
end

