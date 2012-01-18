require_relative '../lib/duck'
require_relative './conveniences'

class Answer
  @@evaluations = 0
  attr_accessor :scores
  attr_accessor :script
  attr_accessor :tokens
  attr_accessor :birth_order
  
  
  def initialize(tokens)
    @tokens = tokens
    @script = tokens.join(" ")
    @scores = {}
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
    @scores[:error] = residuals.inject(:+)
    
    @@evaluations += 1
    @birth_order = @@evaluations
    @scores[:youth] = -@birth_order
    
    @scores[:script_length] = @script.length

    out_file.puts "#{@@evaluations},#{@scores[:error]},#{@scores[:youth]},#{@scores[:script_length]}" unless out_file.nil?
  end
  
  
  def dominated_by?(other_answer, comparison_criteria = self.scores.keys)
    could_be_identical = true
    
    comparison_criteria.each do |score|
      return false if (my_score = self.scores[score]) < (other_score = other_answer.scores[score])
      
      if could_be_identical
        could_be_identical &&= (my_score == other_score)
      end
    end
    
    return !could_be_identical
  rescue NoMethodError
    false
  end
end



def screen(array_of_answers)
  criteria = [:error, :youth, :script_length]
  result = []

  array_of_answers.each do |a|
    if criteria.nil?
      winner = array_of_answers.inject(true) {|anded, b| anded && (!a.dominated_by?(b))}
    else
      winner = array_of_answers.inject(true) {|anded, b| anded && (!a.dominated_by?(b, criteria))}
    end
    result << a if winner
  end
  return result
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

@experiment_tokens = SIMPLE_TOKENS

# EXERCISE (time and materials)
pop_size = 100
updates = pop_size*5
cycles = 200
population = pop_size.times.collect {Answer.new(random_tokens(50,@experiment_tokens))}

File.open("./data/alps_scores_ignore.csv", "w") do |tracefile|

  puts "\n\n# evaluating initial population..."
  population.each do |a|
    a.evaluate(@x_y_values,tracefile) if a.scores.empty?
  end

  cycles.times do |c|
    population.sort_by! {|a| a.scores[:error]*100+a.scores[:script_length]}
    puts "\n\n# After #{c*updates} updates"
    population.each do |a|
      puts "# #{a.scores[:youth]} : #{a.scores[:error]} : #{a.script.inspect}"
    end
    
    # NEW BLOOD
    pop_size.times do
      population << Answer.new(random_tokens(50,@experiment_tokens))
    end
    
    updates.times do |g|
      population.each do |a|
        a.evaluate(@x_y_values,tracefile) if a.scores.empty?
      end

      # BREED
      mom = population.delete_at(rand(population.length))
      dad = population.delete_at(rand(population.length))
  
      crossover1,crossover2 = mom.crossover_result(dad, false)
      
      family = [mom,dad]
      family << Answer.new(crossover1).mutant(3,@experiment_tokens)
      family << Answer.new(crossover2).mutant(3,@experiment_tokens)
      family << Answer.new((family[2].script.gsub(/\d/) {|d| rand(10).to_s}).split)
      family << Answer.new((family[3].script.gsub(/\d/) {|d| rand(10).to_s}).split)
      
      family.each {|a| a.evaluate(@x_y_values,tracefile) if a.scores.empty?}
      
      family = screen(family)
      population += family
    end
    
    # CULL
    old_pop_size = population.length
    until population.length < pop_size
      tournament = (0...population.length).to_a.sample(10)
      survivors = screen(tournament.collect {|i| population[i].clone})
      population += survivors
      (tournament.sort {|a,b| b <=> a}).each {|i| population.delete_at(i)}
    end
    puts "SCREENED #{population.length} from #{old_pop_size}"
  end
end  # end of file writing