#encoding: utf-8
require_relative '../lib/duck'
require 'timeout'
include Duck



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


500.times do
  (1..20).each do |len|
    begin
      pts = len*(10)
      script = random_script(pts)
      begin
        Timeout::timeout(10) do
          puts"#{pts}, #{interpreter(script:script, binder:{x:int(3)}).run.ticks}"
        end
      rescue Timeout::Error
        puts "TIMEOUT: #{script.inspect}"
        raise
      end
    rescue
      puts "ERROR: #{script.inspect}"
      raise
    end
  end
end