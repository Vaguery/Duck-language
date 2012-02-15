#encoding: utf-8
require_relative '../spec_helper'

describe "oversized results" do
  it "should prohibit more than Item.result_size_limit character results (as inspected strings)" do
    d = interpreter(script:"1000 copies foobar")
    d.run.contents.inspect.should == '[err:[OVERSIZED RESULT]]'
  end
end

