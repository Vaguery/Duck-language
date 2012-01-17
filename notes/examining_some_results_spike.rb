require_relative '../lib/duck'
require_relative '../examples/conveniences'

DuckInterpreter.new("x inc x 0 x + / * greedy x -9 x ≥ be x dec > greedy + x -5 -8 ∨ 8 copy x -9 inc 6 x swap x / x -3 8 inc 5 inc x T - -4 3 -95 x + * -7 *",{"x"=>Int.new(4)}).cartoon_trace


(-10..10).each do |x|
  d = DuckInterpreter.new("x T x swap x greedy depth -1 -6 9 -7 x copy x x 7 -7 > x * F depth copy * ∧ x - -9 * -",
  {"x" => Int.new(x)})
  d.run
  puts "#{x}, #{d.stack[d.topmost_respondent("neg")]}, #{(x*x - 15*x + 2012)}"
end