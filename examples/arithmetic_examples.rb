require_relative '../lib/duck'


# a couple of convenience methods in the DuckInterpreter class, for this example
class DuckInterpreter
  def cartoon_of_state
    puts "#{@stack.inspect}   <<<  #{@queue.inspect}  <<<  #{@script.inspect}"
  end
  
  def cartoon_trace
    puts "\n\nrunning \"#{self.script}\""
    puts "(stack) <<< (queue) <<< (script)"
    self.cartoon_of_state
    until @queue.empty? && @script == "" do
      self.step
      cartoon_of_state
    end
  end
end


# seeing arithmetic 'Forth' style (postfix only)
ducky = DuckInterpreter.new("1 2 3 4 5 + * - +")
ducky.cartoon_trace


# seeing arithmetic via partial application of functions
ducky.reset("- * + 5 4 3 2").cartoon_trace


# noting that Closure and Message objects on the stack are functions 'waiting' for arguments
ducky.reset("+ 1").cartoon_trace
puts "\n... adding some new characters to the script on the fly and running more...\n\n"
ducky.script = "1000"
ducky.cartoon_of_state
ducky.step
ducky.cartoon_of_state
ducky.step
ducky.cartoon_of_state


# an amusing arithmetic experiment
puts "\n\n\nAn Amusing Experiment"
jumble_tokens = "11 -22 33 + *".split
jumble_tokens.permutation.each do |s|
  script = s.join(" ")
  puts "running \"#{script}\" ---> #{ducky.reset(script).run.stack.inspect}"
end

