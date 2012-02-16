require_relative '../lib/duck'
include Duck

require_relative '../examples/random_program_trace_example'

def arbitrary_code(how_much)
  runner = interpreter(script:random_script(how_much))
  runner.greedy_flag = false
  runner.run.contents
end

class List
  duck_handle :apply do
    Closure.new(["be"], "apply(#{self.inspect}).to(?)") do |arg|
      scratch = Assembler.new(contents:[arg], buffer:self.contents).run
      scratch.contents.keep_if {|i| i.kind_of?(Number)}[-1]
    end
  end
end


fxn = arbitrary_code(50)

puts fxn.inspect
(-10..30).each do |i|
  puts "#{i} -> #{interpreter(
    script:"apply", 
    contents:[int(i),list(fxn.collect {|i| i.deep_copy})],
    binder:{x:int(10)}
    ).run.contents[-1]}"
end