require_relative '../lib/duck'
require_relative '../examples/conveniences'

DuckInterpreter.new("x inc x 0 x + / * greedy x -9 x ≥ be x dec > greedy + x -5 -8 ∨ 8 copy x -9 inc 6 x swap x / x -3 8 inc 5 inc x T - -4 3 -95 x + * -7 *",{"x"=>Int.new(4)}).cartoon_trace