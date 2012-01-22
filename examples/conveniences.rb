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
  
  def topmost_respondent(message)
    @stack.rindex {|i| i.recognize_message?(message)}
  end
end


# let's just sample all the tokens we have available, and add some extra literals in
def random_script(length)
  template = random_tokens(length)
  template.join(" ")
end

@all_functions = ["+","-","*","/","neg","¬","∧","∨","depth","inc","dec","eql","<",">","≤","≥","be","pop","swap",  "if", "greedy?", "greedy", "ungreedy", "do", "know?", "shatter", "copy", "(", ")", "<<", ">>", "pop", "shift", "unshift" ]
@biased_literals = ['T','F','k','k','k','x','x','x']*5


def random_tokens(length,tokens=@all_functions+@biased_literals)
  length.times.collect do |t|
    t = tokens.sample
    t = (rand(20)-10).to_s if t == 'k'
    t
  end
end


