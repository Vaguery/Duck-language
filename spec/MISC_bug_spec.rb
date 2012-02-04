#encoding: utf-8
require_relative './spec_helper'
require 'timeout'

describe "various bad behaviors that cropped up during stress-testing" do
  it "should be able to deal with Bad Script 1" do
    d = DuckInterpreter.new("F x swap know? ≤ ( eql pop pop x -7 x ( T know? ) inc -3 -8 8 F copy << 4 x neg ≥ -3 greedy 6 ≤ < 7 depth T ¬ F + -8 x -8 do -8 greedy? ≤ / pop -2 x > + -7 ≤ T ≤ ( pop ∨ - do dec 9 ( x 3 4 know? << T F F if + 9 x ∧ 8 -2 / -1 unshift < -5 x - x ( x > F 8 x - F know? x T << neg if F -7 x T eql 4 9 ( T ) T ungreedy > x x ( x - x x x ≥ x << know? << < -7 T x x ) copy F do ∧ -4 x 9 if F neg ≤ copy F eql x -8 ∧ x unshift x x x > F x copy inc > swap dec greedy / 6 -7 -10 be -7 x << ≤ x 0 7 -4 1 ∨ dec -4 x do T F x ungreedy F F be x x copy T neg < x 1 T < shatter x x x -1 ( << -4 << -2 x 8 + 0 x 6 swap copy inc T T 0 ∨ x eql pop", {"x" => Int.new(8)})
    
    lambda{ d.run }.should_not raise_error
  end
  
  it "should be able to deal with Bad Script 2" do
    d = DuckInterpreter.new("inc < F -9 F 4 pop << 4 F x x x << << T -9 do greedy ∨ inc 4 greedy 3 -6 be unshift x -3 x -10 greedy x ) if ≤ ) 8 F ∨ -2 neg > swap x ) x x x T T ) -9 ¬ T -1 ∧ -4 ungreedy x ) know? neg at T -9 do greedy ∨ inc 4 greedy 3 -6 be unshift x -3 x -10 greedy x ) if ≤ ) 8 F ∨ -2 neg > swap x ) x x x T T ) -9 ¬ T -1 ∧ -4 ungreedy x ) know? neg",{"x" => List.new(*[Int.new(8)])})
    
    lambda{ d.run }.should_not raise_error
  end
  
  it "should be able to deal with Bad Script 3" do
    d = DuckInterpreter.new(">> x 1.379 depth T -6.819 -4 pop x known < T 8 neg - x T x x -4.156 []= T F * pop if ungreedy 8.593 []= 5.353 << F >> 1.184 neg x 8 7.707 swap F swap x x -2 ungreedy x 6 x x -5",{"x" => Int.new(8)})
    
    lambda{ d.run }.should_not raise_error
  end
  
  
  it "should be able to deal with Bad Script 4" do
    d = DuckInterpreter.new("-5.957 known zap neg T ¬ -3.836 x / give x x x -9.557 3 -5 F -1.88 be ( depth 7 F zap x neg trunc -8.82 x T 6.336 shift -7.108 neg neg -2.772 pop -5 T + F 2.861 greedy x shift be x 6 x x",{"x" => Int.new(8)})
    
    lambda{ d.run }.should_not raise_error
  end
  
  
  it "should be able to deal with Bad Script 4" do
    d = DuckInterpreter.new("eql empty x ( -3.777 - < << give 4.214 known ≥ / T eql < x -6.333 []= copy be 5 << if zap ∧ 2.496 pop x know? -3 dec T F x depth F empty F greedy unshift x -7 ∧ greedy? -8 -6 x greedy copy",{"x" => Int.new(8)})
    
    lambda{ d.run }.should_not raise_error
  end
  
  it "should be able to deal with Very Slow Bad Script 5" do
    d = DuckInterpreter.new("x F pop ungreedy 0 x 4.025 T ) 9 x 4.436 swap copy T x trunc eql 0.626 swap 7 swap x []= 3.687 x -3.38 -10 -4 greedy ∨ x greedy ( x quote ) map F shatter eql x + ¬ []= inc known [] depth x trunc x 3.700 -2 ∧ 1.578 x T map map eql unshift 5.036 -7.378 - 9 know? do reverse x", {"x" => Int.new(12)})
    lambda { 
      Timeout::timeout(2) do |t|
        d.run
      end
    }.should_not raise_error
  end
end

