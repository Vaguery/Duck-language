# a couple of convenience methods in the DuckInterpreter class, for this example
class DuckInterpreter
  def cartoon_of_state
    puts "#{@stack.inspect}   <<<  #{@queue.inspect}  <<<  #{@script.inspect}"
  end
  
  def cartoon_trace
    counter = 0
    puts "\n\nrunning \"#{self.script}\""
    puts counter
    puts "(stack) <<< (queue) <<< (script)"
    self.cartoon_of_state
    until @queue.empty? && @script == "" do
      self.step
      counter += 1
      puts "\n\n#{counter}"
      puts "greedy: #{@greedy_flag}"
      puts "characters: #{@stack.to_s.length} : #{@queue.to_s.length} : #{@script.length}"
      # puts "stack contains: #{item_tree(@stack)}"
      # puts "queue contains: #{item_tree(@queue)}"
      cartoon_of_state
    end
  end
  
  def topmost_respondent(message)
    @stack.rindex {|i| i.recognize_message?(message)}
  end
  
  def item_tree(array)
    id_tree = array.inject("(") do |tree,item|
      if [Bundle,Bundler].include? item.class
        subtree = "#{item.class}[#{item.object_id}]:#{item_tree(item.contents)}, "
      else
        subtree = "#{item.class}[#{item.object_id}], "
      end
      tree += subtree
    end
    id_tree.chop.chop + ")"
  end
end


# let's just sample all the tokens we have available, and add some extra literals in
def random_script(length)
  template = random_tokens(length)
  template.join(" ")
end

@all_functions = ["+","-","*","/","neg","¬","∧","∨","depth","inc","dec","eql","<",">","≤","≥","be","pop","swap",  "if", "greedy?", "greedy", "ungreedy", "do", "know?", "shatter", "copy", "(", ")", "<<", ">>", "pop", "shift", "unshift", "reverse", "empty", "zap", "quote", "[]", "known", "trunc", "[]=", "give", "map", "users", "useful", "∪", "∩", "flatten", "snap", "rewrap_by"]
@biased_literals = ['T','F','k','k','k','f','f','f','b','b','b','x','x','x']*5


def random_tokens(length,tokens=@all_functions+@biased_literals)
  length.times.collect do |t|
    t = tokens.sample
    t = (rand(20)-10).to_s if t == 'k'
    t = ['T','F'].sample if t == 'b'
    t = ((rand()*20-10.0).round(3)).to_s if t == 'f'
    t
  end
end


