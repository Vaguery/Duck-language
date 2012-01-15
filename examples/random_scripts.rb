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


# let's just sample all the tokens we have available, and add some extra literals in
def random_script(length)
  tokens = ["+","-","*","/","neg","¬","∧","∨","depth","inc","dec","eql","<",">","≤","≥"] + ['T','F','k','k','k']*5

  template = length.times.collect do |t|
    t = tokens.sample
    t = (rand(1000)-500).to_s if t == 'k'
    t
  end
  template.join(" ")
end


# how do random scripts 'look'? What do they produce?
puts "some random Duck scripts, and the final stack state when they're run...\n"
10.times do
  s = random_script(100)
  d = DuckInterpreter.new(s).run
  puts "script:\n#{d.old_script.inspect}\n\nproduces:\n#{d.stack.inspect}\n\n\n"
end


# What happens when they run?
puts "Tracing execution of a random Duck script:"
DuckInterpreter.new(random_script(30)).cartoon_trace