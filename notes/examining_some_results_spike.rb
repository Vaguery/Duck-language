require_relative '../lib/duck'
require_relative '../examples/conveniences'

# DuckInterpreter.new("x -8 -2 x -3 if x x * x x x 7 - x * x 7 7 * inc 3 -2 - * - dec -8 * +",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("x -263 / x * x -888 / inc x if -885 * 539 905 x x -13 dec + * x -262 + dec 944 - - 805 +",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("copy copy depth ≤ T neg be",{"x"=>Int.new(4)}).cartoon_trace
# 
# DuckInterpreter.new("-445 x x x 978 572 x * if 504 / - x * x x x dec -172 30 x - x x dec inc * if + -35 x 761 776 / * x x x * 207 x inc x * 37 -925 215 inc -682 +",{"x" => [Int.new(3),Int.new(4)]}).cartoon_trace
# 
# DuckInterpreter.new("x x * dec x ∨ x + * + depth +",{"x" => [10, 3, 6, 0, 5, 0, 5, 2, 2, 0, 4, 5, 0, 6, 1, 2, 3, 5, 5, 0].collect{|i| Int.new(i)}}).cartoon_trace

# DuckInterpreter.new("x x < 509 inc inc < x x * x ∨ depth ∧ 328 ∧ > > -980 - x x depth x + eql depth x x < eql ∨ * ∨ x > inc dec * * x > ∧ * eql / - inc - eql depth 320 depth -",{"x" => [10, 3, 6, 0, 5, 0, 5, 2, 2, 0, 4, 5, 0, 6, 1, 2, 3, 5, 5, 0].collect{|i| Int.new(i)}}).cartoon_trace


DuckInterpreter.new("F x swap know? ≤ ( eql pop pop x -7 x ( T know? ) inc -3 -8 8 F copy << 4 x neg ≥ -3 greedy 6 ≤ < 7 depth T ¬ F + -8 x -8 do -8 greedy? ≤ / pop -2 x > + -7 ≤ T ≤ ( pop ∨ - do dec 9 ( x 3 4 know? << T F F if + 9 x ∧ 8 -2 / -1 unshift < -5 x - x ( x > F 8 x - F know? x T << neg if F -7 x T eql 4 9 ( T ) T ungreedy > x x ( x - x x x ≥ x << know? << < -7 T x x ) copy F do ∧ -4 x 9 if F neg ≤ copy F eql x -8 ∧ x unshift x x x > F x copy inc > swap dec greedy / 6 -7 -10 be -7 x << ≤ x 0 7 -4 1 ∨ dec -4 x do T F x ungreedy F F be x x copy T neg < x 1 T < shatter x x x -1 ( << -4 << -2 x 8 + 0 x 6 swap copy inc T T 0 ∨ x eql pop",{"x" => Int.new(7)}).cartoon_trace