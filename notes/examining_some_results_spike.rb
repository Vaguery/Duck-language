require_relative '../lib/duck'
require_relative '../examples/conveniences'

DuckInterpreter.new("x -8 -2 x -3 if x x * x x x 7 - x * x 7 7 * inc 3 -2 - * - dec -8 * +",{"x"=>Int.new(4)}).cartoon_trace

DuckInterpreter.new("-8 * x x dec x -7 if x dec - x 7 - + * x 7 7 * inc 3 -2 - * - dec -8 * +",{"x"=>Int.new(4)}).cartoon_trace