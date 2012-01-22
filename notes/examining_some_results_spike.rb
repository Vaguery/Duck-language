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


DuckInterpreter.new("x - ( eql x shatter x if depth 455 x copy -120 neg ) know? x T know? be 397 x 17 ungreedy + / 921 989 -633 x 609 + F ≤ 109 be 439 depth if ) - + 514 x ¬ know? x pop if x",{"x" => Int.new(7)}).cartoon_trace