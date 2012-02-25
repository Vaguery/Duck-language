#encoding: utf-8
require_relative '../lib/duck'
require 'timeout'
include Duck

############
# A simple experiment in the diversity of Duck scripts.
#
# We generate Duck scripts from random tokens, run them with different inputs 'x'
#   to observe how many act differently with just the change in inputs value.


######
# some conveniences, first:

ARITHMETIC_TOKENS = ["+","-","*","/","inc","dec","if"] + ['k','f','x'] * 5
ALL_MESSAGES =
  [Assembler,Binder,Bool,Closure,Collector,
  Decimal,Error,Int,Interpreter,Item,Iterator,List,Local,
  Message,Number,Pipe,Proxy,Script,Span,Variable].inject([]) {|messages,klass| (messages | klass.recognized_messages)}
  
@everything = 
  ALL_MESSAGES + ['m','k','b','f','x'] * 10

def random_tokens(how_many,source_list)
  tokens = how_many.times.collect do
    t = source_list.sample
    case
    when t=="k" # some random integer
      val = "#{(0..9).to_a.sample}"
      rand < 0.5 ? val : "-#{val}"
    when t=="m" # some random local message
      "_#{('a'..'z').to_a.sample}"
    when t=="b" # some random boolean
      rand < 0.5 ? "T" : "F"
    when t=="f" # some random float
      val = "#{(0..9).to_a.sample}.#{(0..9).to_a.sample}"
      rand < 0.5 ? val : "-#{val}"
    else # just what it says
      t.to_s
    end
  end
end


def random_script(how_many, source_list=@everything)
  parts = random_tokens(how_many, source_list)
  parts.join(" ")
end

############
#
# We generate 500 random 50-token scripts
# set variable :x1 and :x2
# run each script, and count the number of ticks execution takes,
# and report the top two Number values present on the interpreter when it's done


puts "trial, ticks(x1), ticks(x2), y1(x1), y1(x2), y2(x1), y2(x2)"
(0..500).each do |i|
  pts = 100
  x1 = 16
  x2 = 19
  script = random_script(pts)
  begin
    Timeout::timeout(120) do
      random_one = interpreter(script:script, binder:{x:int(x1)}).run
      random_two = interpreter(script:script, binder:{x:int(x2)}).run
      puts"#{i}: #{random_one.ticks}, #{random_two.ticks}, #{random_one.emit!(Number)||'nil'}, #{random_two.emit!(Number)||'nil'}, #{random_one.emit!(Number)||'nil'}, #{random_two.emit!(Number)||'nil'}"
    end
  rescue Exception => e
    puts "ERROR:#{e.message} -- #{e.backtrace} #{script.inspect}"
    raise
  end
end