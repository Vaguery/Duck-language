#encoding: utf-8

class NewClosure
  attr_accessor :actor
  attr_accessor :args
  attr_accessor :needs
  attr_accessor :image
  attr_accessor :outcome
  
  def initialize(actor, image, set_args, needed_args, &outcome)
    @actor = actor
    @image = image
    @args = set_args
    @needs = needed_args
    @outcome = outcome
  end
  
  def to_s
    arg_image = @outcome.parameters.inject("") do |memo,parm|
      p = parm[1]
      arg = p == :actor ? @actor : @args[p]||"█#{@needs[p].inspect}"
      "#{memo}#{arg},"
    end
    "λ:#{@image.intern}(#{arg_image.chop})"
  end
  
  
  def curry(argname, argvalue)
    @needs.delete(argname)
    @args[argname] = argvalue
    @needs.empty? ? self.final_call : self
  end
  
  
  def final_call
    arg_list = @outcome.parameters.collect do |parm|
      p = parm[1]
      p == :actor ? @actor : @args[p]
    end
    @outcome.call(arg_list)
  end
end


puts nc = NewClosure.new(3, "plus2", {}, {:arg1 => :neg, :arg2 => :neg}) {|actor,arg1,arg2| actor+arg1+arg2}
puts nc.curry(:arg2,2)
puts nc.curry(:arg1,8)



accumulator = NewClosure.new([], "<<", {}, {:arg1 => :be}) {}
accumulator.outcome = proc do |actor,arg1|
  accumulator.actor << arg1
  accumulator
end

puts accumulator.inspect
puts accumulator.curry(:arg1, 3)
puts accumulator.curry(:arg1, 4)