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
  
  
  def evaluate(x_y_pairs_hash={},out_file = nil)
    residuals = x_y_pairs_hash.collect do |x,y|
      d = DuckInterpreter.new(@script,{"x" => Int.new(x)}).run
      observed_y_location = d.topmost_respondent("neg")
      observed_y = observed_y_location.nil? ? 10000000 :
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



def screen(array_of_answers, criteria=[:error, :youth, :script_length])
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
(1..20).each do |i| 
  x = i*33
  @x_y_values[x] = 9*x*x - 11*x + 1964
  puts "# training #{x} -> #{@x_y_values[x]}"
end

#####
#
# repeated random guessing with multiple objectives
#
#####

SIMPLE_TOKENS = ["+","-","*","/","inc","dec","if"]+['k','k','k','x','x','x']*2
NUMBERLESS_TOKENS = ["+","-","*","/","inc","dec"]+['x']*4
ALL_TOKENS = @all_functions + @biased_literals # from ./conveniences.rb

@experiment_tokens = ALL_TOKENS


guesses = 100
cycles = 100
answers_found_so_far = []

File.open("./data/MOguessing_scores_4d20_tokens_ignore.csv", "w") do |tracefile|
  cycles.times do |c|
    answers_found_so_far.sort_by! {|a| a.scores[:error]*100 + a.scores[:script_length]}
    puts "\n\n"
    answers_found_so_far.each do |a|
      tracefile.puts "##{c} : #{a.scores[:error]} : #{a.scores[:youth]} : #{a.script}"
      puts "##{c} : #{a.scores[:error]} : #{a.scores[:youth]} : #{a.script}"
    end
    
    guesses.times do |g|
      answers_found_so_far << Answer.new(random_tokens(rand(50)+rand(50)+rand(50)+rand(50),@experiment_tokens))
    
      answers_found_so_far.each do |a|
        a.evaluate(@x_y_values,tracefile) if a.scores.empty?
      end
    
      # CULL
      answers_found_so_far = screen(answers_found_so_far)
    end
  end
end  # end of file writing