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


DuckInterpreter.new("1121 ( ) shatter").cartoon_trace

# DuckInterpreter.new("depth x x -744 < x inc 290 ≥ T -323 ( ( -688 ≥ 314 x eql dec neg F ¬ -636 224 ∧ x ∧ / neg x be ( ungreedy ) ∨ ( neg dec dec -242 F T ( 960 T x F dec / F -451 F -771 T -156 shatter T",{"x" => [10, 3, 6, 0, 5, 0, 5, 2, 2, 0, 4, 5, 0, 6, 1, 2, 3, 5, 5, 0].collect{|i| Int.new(i)}}).cartoon_trace
# 
# # 
# "x ungreedy do x ∧ -652 dec inc ( do > T -410 ≥ x F x T inc F > 679 pop -332 x - ≤ T depth F x depth x -455 -60 61 inc - T -368 T ( ) shatter x"
# 
# "if ( greedy know? ( 26 T shatter 240 x 978 < do shatter x do be be x T F swap x ungreedy x x F ≤ ( ) ≤ x ≥ pop copy -269 109 T shatter -479 x x greedy x 273 ( x F 852 x / x > x ≥ T / F T pop x F"