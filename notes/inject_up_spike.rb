require_relative '../lib/duck'
include Duck

class List
  def contents_recognized_messages
    @contents.inject([]) {|msgs, item| (msgs|item.class.recognized_messages|item.singleton_methods)}
  end
  
  def index_of_next_respondent_to(msg)
    @contents.rindex {|arg| arg.recognize_message?(msg.intern)}
  end
end

number_list = (0..6).collect {|i| int(i*i+8)}

actor = message("swap")

# "halt 5 8 F 1.8 ∨ T dec swap * F 6 0 2 x F flatten to_decimal eql if T T fold_down unshift to_decimal to_list run if F bind eql F inc - x - ÷ bind * to_list T * do halt copy"

a = assembler( contents:number_list, buffer:[actor] )
a.greedy_flag = false


until actor.needs.empty? || a.index_of_next_respondent_to(actor.needs[0]).nil? do
  old_length = a.contents.length
  puts a.run.inspect
  a.contents.pop if a.contents.length >= old_length
  a.buffer = [actor]
end