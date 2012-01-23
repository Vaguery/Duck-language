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


# bowling score performance space:
training_data = {[8, 1, 2, 0, 0, 5, 10, 4, 2]=>32, [10, 7, 0, 3, 0, 0, 0, 0, 0]=>27, [2, 1, 7, 2, 8, 1, 2, 4, 7, 1]=>35, [7, 2, 4, 3, 5, 1, 10, 4, 0]=>40, [10, 4, 6, 5, 1, 8, 1, 5, 2]=>57, [2, 7, 3, 7, 5, 2, 2, 2, 1, 5, 7, 0]=>48, [0, 3, 9, 0, 0, 10, 8, 1, 9, 0, 6, 3]=>57, [10, 8, 0, 8, 0, 10, 8, 0, 0, 8]=>68, [10, 4, 6, 9, 0, 6, 2, 6, 4, 0, 9]=>75, [7, 2, 6, 4, 10, 9, 0, 6, 4, 3, 6]=>79, [3, 3, 5, 3, 1, 4, 8, 0, 7, 3, 7, 0, 2, 7]=>60, [10, 4, 3, 0, 4, 3, 1, 1, 9, 8, 2, 2, 1]=>65, [6, 1, 8, 1, 2, 5, 9, 1, 5, 5, 8, 0, 5, 1]=>70, [3, 0, 9, 1, 9, 0, 7, 0, 7, 2, 10, 5, 2]=>71, [0, 3, 10, 10, 3, 1, 4, 1, 5, 5, 4, 5]=>72, [6, 2, 10, 5, 3, 6, 2, 2, 3, 9, 1, 5, 5, 8]=>80, [1, 2, 9, 1, 6, 1, 10, 6, 4, 10, 6, 0]=>88, [4, 1, 0, 0, 8, 0, 0, 5, 2, 0, 6, 0, 3, 4, 6, 2]=>41, [0, 0, 9, 0, 2, 5, 8, 1, 5, 1, 2, 4, 1, 1, 7, 2]=>48, [1, 8, 4, 2, 1, 6, 3, 1, 9, 0, 0, 4, 7, 1, 4, 2]=>53, [10, 0, 3, 9, 1, 3, 1, 3, 2, 1, 2, 8, 1, 1, 4]=>55, [0, 5, 6, 4, 1, 6, 2, 4, 10, 3, 2, 5, 1, 1, 3]=>59, [8, 1, 2, 4, 0, 1, 5, 0, 5, 5, 8, 1, 9, 0, 6, 0]=>63, [6, 2, 7, 1, 2, 3, 6, 3, 5, 5, 3, 3, 3, 3, 4, 6, 7]=>72, [6, 0, 10, 8, 0, 4, 5, 5, 4, 2, 3, 1, 3, 10, 5, 1]=>75, [6, 4, 3, 1, 3, 6, 5, 4, 7, 1, 5, 1, 8, 1, 10, 7, 2]=>77, [6, 2, 4, 3, 4, 5, 0, 4, 9, 1, 3, 7, 9, 0, 4, 5]=>78, [10, 8, 0, 1, 3, 1, 9, 5, 0, 10, 0, 2, 9, 1, 6]=>80, [2, 3, 4, 6, 2, 5, 7, 1, 10, 4, 3, 6, 4, 10, 5, 4]=>95, [2, 1, 9, 0, 9, 0, 6, 3, 6, 4, 6, 4, 2, 4, 4, 4, 6, 2]=>80, [3, 4, 8, 0, 4, 5, 6, 4, 7, 1, 9, 0, 1, 3, 4, 6, 6, 1]=>85, [3, 4, 8, 1, 3, 4, 5, 3, 4, 1, 8, 2, 4, 5, 10, 2, 8, 1]=>90, [8, 2, 2, 2, 10, 1, 6, 10, 7, 2, 1, 7, 10, 2, 7]=>104}

perf = training_data.collect do |key, value|
  d = DuckInterpreter.new( "neg < pop -4 T -7 9 x F << -8 eql -54 if -9 0 - x greedy? - F T / eql < dec T pop ¬ 0 < x 3 -3 2 -6 T greedy? x T depth",{"x" => Bundle.new(*key.each.collect{|i| Int.new(key[i])}) } ).run
  where = d.topmost_respondent("neg")
  puts where
  puts d.stack.inspect
  (value - d.stack[where].value).abs
end

puts perf.inspect