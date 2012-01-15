require_relative '../lib/duck'
require_relative './conveniences'


# how do random scripts 'look'? What do they produce?
puts "some random Duck scripts, and the final stack state when they're run...\n"
10.times do
  s = random_script(100)
  d = DuckInterpreter.new(s).run
  puts "script:\n#{d.old_script.inspect}\n\nproduces:\n#{d.stack.inspect}\n\n\n"
end



# What happens when they run?
puts "Tracing execution of a random Duck script: (x=991)"
DuckInterpreter.new("ungreedy "+random_script(30),{"x" => Int.new(991)}).cartoon_trace



# What changes in a random function's behavior, given a variety of x 'inputs'?
puts "\n\nStack after executing a random Duck script with various assignments of 'x':"
random_function = random_script(30)
puts "\n#{random_function.inspect}\n\n"
30.times do
  val = rand(100)-50
  script = DuckInterpreter.new(random_function,{"x" => Int.new(val)})
  script.run
  puts "#{script.stack.inspect} when x=#{val}"
end
