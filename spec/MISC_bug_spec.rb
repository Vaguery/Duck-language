#encoding: utf-8
require_relative './spec_helper'

describe "various bad behaviors that cropped up during stress-testing" do
  it "should be able to deal with Bad Script 1" do
    d = DuckInterpreter.new("F x swap know? ≤ ( eql pop pop x -7 x ( T know? ) inc -3 -8 8 F copy << 4 x neg ≥ -3 greedy 6 ≤ < 7 depth T ¬ F + -8 x -8 do -8 greedy? ≤ / pop -2 x > + -7 ≤ T ≤ ( pop ∨ - do dec 9 ( x 3 4 know? << T F F if + 9 x ∧ 8 -2 / -1 unshift < -5 x - x ( x > F 8 x - F know? x T << neg if F -7 x T eql 4 9 ( T ) T ungreedy > x x ( x - x x x ≥ x << know? << < -7 T x x ) copy F do ∧ -4 x 9 if F neg ≤ copy F eql x -8 ∧ x unshift x x x > F x copy inc > swap dec greedy / 6 -7 -10 be -7 x << ≤ x 0 7 -4 1 ∨ dec -4 x do T F x ungreedy F F be x x copy T neg < x 1 T < shatter x x x -1 ( << -4 << -2 x 8 + 0 x 6 swap copy inc T T 0 ∨ x eql pop", {"x" => Int.new(8)})
    
    lambda{ d.run }.should_not raise_error
  end
end


