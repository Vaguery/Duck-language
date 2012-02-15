#encoding: utf-8
require_relative '../lib/duck'
include Duck

# seeing arithmetic 'Forth' style (postfix only)
ducky = Interpreter.new(script:"1 2 3 4 5 + * - +")
puts ducky.trace!.run.saved_trace



# seeing arithmetic via partial application of functions
puts "\n\n"
ducky.reset(script:"- * + 5 4 3 2")
puts ducky.trace!.run.saved_trace


# noting that Closure and Message objects on the stack are functions 'waiting' for arguments
puts "\n\n"
ducky.reset(script:"+ 1")
puts ducky.trace!.run.saved_trace
puts "\n... adding '1000 999 998 * * *' to the empty script on the fly, then running more...\n\n"
ducky.script.value = "1000 999 998 * * *"
puts ducky.trace!.run.saved_trace

# an amusing arithmetic experiment
puts "\n\n\nAn Amusing Experiment"
jumble_tokens = "1 -22 333 + *".split
jumble_tokens.permutation.each do |s|
  script = s.join(" ")
  d = Interpreter.new(script:script)
  puts "running \"#{script}\" ---> #{d.run.contents[0].inspect}"
end

