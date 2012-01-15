require_relative '../lib/duck'
require_relative './conveniences'


#   A trivial (and not too smart) implementation of genetic programming in Duck:
#   
#   A population of Answer objects is created at random, evaluated, and
#   then pairs are chosen at random for "breeding" by one-point crossover
#   and mutation. The two "babies" are scored, and the best pair of [parents+babies]
#   is replaced in the population. That would be steady-state evolutionary search,
#   by the way.
#
#   Every time an Answer is evaluated, its score and script length (in characters)
#   is printed to the console (for subsequent analysis in an exercise); every few hundred
#   iterations, a complete list of the Answers in the population is printed, sorted by
#   score.
#
#   The target function can be modified by changing the hash @x_y_values
#   to contain numerical values for data being "modeled" by the programs.


class Answer
  attr_accessor :score
  attr_accessor :script
  attr_accessor :tokens
  
  def initialize(tokens)
    @tokens = tokens
    @script = tokens.join(" ")
    @score = nil
  end
  
  
  def crossover_result(other_answer)
    
    cut_point = rand(@tokens.length)
    babies = [
      @tokens[0..cut_point] + other_answer.tokens[cut_point+1..-1],
      other_answer.tokens[0..cut_point] + @tokens[cut_point+1..-1]]
    return babies
  end
  
  
  def mutant(zaps=1,choices=["be"])
    mutant_tokens = @tokens.clone
    zaps.times do
      mutant_tokens[rand(mutant_tokens.length)] = random_tokens(1,choices)[0]
    end
    return Answer.new(mutant_tokens)
  end
  
  
  def evaluate(x_y_pairs_hash={})
    residuals = x_y_pairs_hash.collect do |x,y|
      d = DuckInterpreter.new(@script,{"x" => Int.new(x)}).run
      observed_y_location = d.topmost_respondent("neg")
      observed_y = observed_y_location.nil? ? 1000000 :
        (x_y_pairs_hash[x] - d.stack[observed_y_location].value).abs
    end
    self.score = (residuals.inject(:+))
    puts "#{self.score},#{self.script.length}"
  end
end

# target data for symbolic regression
@x_y_values = {}
(-10..10).each {|i| @x_y_values[i] = i*i - 15*i + 2012}


# simpleminded steady-state GP
@simpler_tokens = ["+","-","*","/","inc","dec"]+['k','k','k','x','x','x']*2
@all_tokens = @all_functions+@biased_literals

pop_size = 100
updates = pop_size
cycles = 100
population = pop_size.times.collect {Answer.new(random_tokens(32,@simpler_tokens))}


puts "\n\n# evaluating initial population..."
population.each do |a|
  a.evaluate(@x_y_values) if a.score.nil?
end

cycles.times do |c|
  population.sort_by! {|a| a.score}
  puts "# After #{c*updates} updates"
  population.each do |a|
    puts "# #{a.score}: #{a.script.inspect}"
  end
  
  (95..-1).each {|i| population[i] = Answer.new(random_tokens(32,@simpler_tokens))}
  
  updates.times do |g|
    population.each do |a|
      a.evaluate(@x_y_values) if a.score.nil?
    end
  
    mom_index, dad_index = rand(pop_size), rand(pop_size)
    mom, dad = population[mom_index], population[dad_index]
    
    crossover1,crossover2 = mom.crossover_result(dad)
    baby1 = Answer.new(crossover1).mutant(2,@all_tokens) # some innovative junk gets inserted, here
    baby2 = Answer.new(crossover2).mutant(2,@all_tokens)
    
    baby1.evaluate(@x_y_values)
    baby2.evaluate(@x_y_values)
  
    family = [mom,dad,baby1,baby2].sort_by {|a| a.score}
    population[mom_index] = family[0]
    population[dad_index] = family[1]
  end
  
end