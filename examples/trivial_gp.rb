require_relative '../lib/duck'
require_relative './conveniences'


#   A trivial (and not at all smart!) implementation of genetic programming in Duck:
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
#   (The trace can be saved to a csv file and read into an R variable with the R code:
#     d = read.csv([filename],comment.char="#",blank.lines.skip=TRUE,
#         col.names=c("step","score","chars")))
#
#   The target function can be modified by changing the hash @x_y_values
#   to contain numerical values for data being "modeled" by the programs.
#
#   Various exercises are called out in the code; these are part of a planned workshop, but
#   the implications might be apparent to GP practitioners.


class Answer
  @@evaluations = 0
  attr_accessor :score
  attr_accessor :script
  attr_accessor :tokens
  attr_accessor :birth_order
  
  def initialize(tokens)
    @tokens = tokens
    @script = tokens.join(" ")
    @score = nil
  end
  
  
  def crossover_result(other_answer,even=true)
    my_cut_point = rand(@tokens.length)
    other_cut_point = even ? my_cut_point : rand(other_answer.tokens.length)
    babies = [
      @tokens[0..my_cut_point] + other_answer.tokens[other_cut_point+1..-1],
      other_answer.tokens[0..other_cut_point] + @tokens[my_cut_point+1..-1]]
    return babies
  end
  
  
  def mutant(zaps=1,choices=["be"])
    mutant_tokens = @tokens.clone
    zaps.times do
      mutant_tokens[rand(mutant_tokens.length)] = random_tokens(1,choices)[0]
    end
    return Answer.new(mutant_tokens)
  end
  
  
  def evaluate(x_y_pairs_hash={},out_file = nil)
    residuals = x_y_pairs_hash.collect do |x,y|
      d = DuckInterpreter.new(@script,{"x" => Int.new(x)}).run
      observed_y_location = d.topmost_respondent("neg")
      observed_y = observed_y_location.nil? ? 1000000 :
        (x_y_pairs_hash[x] - d.stack[observed_y_location].value).abs
    end
    @score = residuals.inject(:+)
    # EXERCISE (resonance) @score += rand(@score/100)
    @@evaluations += 1
    @birth_order = @@evaluations

    out_file.puts "#{@@evaluations},#{self.score},#{self.script.length}" unless out_file.nil?
  end
end


# target data for symbolic regression
@x_y_values = {}
(-10..10).each do |i| 
  x = i*3
  @x_y_values[x] = (x*x - 15*x + 2012)
end

#####
#
# simpleminded steady-state GP
#
#####

SIMPLE_TOKENS = ["+","-","*","/","inc","dec","if"]+['k','k','k','x','x','x']*2  # EXERCISE (toolkit)
NUMBERLESS_TOKENS = ["+","-","*","/","inc","dec"]+['x']*4  # EXERCISE (one hand tied)
ALL_TOKENS = @all_functions+@biased_literals

@experiment_tokens = ALL_TOKENS

# EXERCISE (time and materials)
pop_size = 200
updates = pop_size*3
cycles = 500
population = pop_size.times.collect {Answer.new(random_tokens(30,@experiment_tokens))}

File.open("./data/scores.csv", "w") do |tracefile|

  puts "\n\n# evaluating initial population..."
  population.each do |a|
    a.evaluate(@x_y_values,tracefile) if a.score.nil?
  end

  cycles.times do |c|
    population.sort_by! {|a| a.score}
    puts "# After #{c*updates} updates"
    population.each do |a|
      puts "# #{a.birth_order} : #{a.score} : #{a.script.inspect}"
    end

    # EXERCISE (new blood)
    (pop_size-10..pop_size-6).each do |i|
      population[i] = Answer.new(random_tokens(30,@experiment_tokens))
    end

    # EXERCISE (polishing)
    template_source = rand(10)
    (pop_size-5..-1).each do |i|
      population[i] = Answer.new((population[template_source].script.gsub(/\d/) {|d| rand(10).to_s}).split)
    end

    updates.times do |g|
      population.each do |a|
        a.evaluate(@x_y_values,tracefile) if a.score.nil?
      end

      mom_index, dad_index = rand(pop_size), rand(pop_size)
      mom, dad = population[mom_index], population[dad_index]
  
      # EXERCISE (recombination)
      crossover1,crossover2 = mom.crossover_result(dad)
      baby1 = Answer.new(crossover1).mutant(3,@experiment_tokens) # EXERCISE (ontological creep)
      baby2 = Answer.new(crossover2).mutant(3,@experiment_tokens)
  
      baby1.evaluate(@x_y_values,tracefile)
      baby2.evaluate(@x_y_values,tracefile)

      family = [baby1,baby2,mom,dad].sort_by {|a| a.score}  # EXERCISE (selection pressure)
      population[mom_index] = family[0]                     # EXERCISE (selection off)
      population[dad_index] = family[1]
    end

  end
end  # end of file writing