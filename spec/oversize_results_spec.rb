#encoding: utf-8
require_relative './spec_helper'

describe "oversized results" do
  it "should prohibit more than Item.result_size_limit character results (as inspected strings)" do
    d = DuckInterpreter.new("1000 copies foobar")
    d.run.stack.inspect.should == "[err:OVERSIZED RESULT]"
  end
  
  
  it "should be able to deal with oversized/overtime results of recursive mapping" do
    pending
    d = DuckInterpreter.new("x F pop ungreedy 0 x 4.025 T ) 9 x 4.436 swap copy T x trunc eql 0.626 swap 7 swap x []= 3.687 x -3.38 -10 -4 greedy ∨ x greedy ( x quote ) map F shatter eql x + ¬ []= inc known [] depth x trunc x 3.700 -2 ∧ 1.578 x T map map eql unshift 5.036 -7.378 - 9 know? do reverse x", {"x" => Int.new(12)})
    
    d.run
    d.stack.inspect.should == "??"
  end
end

