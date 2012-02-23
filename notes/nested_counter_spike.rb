# Trying to accumulate a count of ticks from all nested iterating objects

class Foo
  @@global_counter = 0
  
  attr_accessor :ticks
  attr_accessor :contents
  attr_reader :name
  
  def initialize(name = "")
    @name = name
    @contents = []
    @ticks = 0
  end
  
  
  def count_a_tick
    @ticks += 1
    @@global_counter += 1
  end
  
  def take_ticks
    record = @ticks
    @ticks = 0
    return record
  end
  
  def step
    count_a_tick
    @contents.each do |item| 
      item.run.tap {@ticks += item.take_ticks}
    end
    puts "#{@@global_counter}: #{@name} takes step #{@ticks}"
    self
  end
  
  
  def run
    5.times {step}
    puts "\n"
    self
  end
end

a = Foo.new("a")
a.contents << Foo.new("b")
a.contents[0].contents << Foo.new("c")
a.contents[0].contents << Foo.new("d")
a.run