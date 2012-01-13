# a design spike for the Duck language's function objects, which are
# - first-class functions
# - partial application
# - duck-typed

# For example, the Duck script
#   "1 +"
# should end up producing a closure that means something like this:
#   1.+(missing("neg"))  -> 1.+(arg)
# where 'missing("neg")' indicates any variable that RESPONDS to the message "neg"

# this works in Ruby 1.9.3 at least....

require 'rspec'

class Closure
  attr_reader :closure
  attr_reader :needs
  
  def initialize(closure,needs)
    @closure = closure
    @needs = needs
  end
  
  def can_use?(object)
    object.respond_to?(@needs[0])
  end
  
  def grab(object)
    if can_use?(object)
      if @needs.length > 1
        Closure.new(@closure.curry[object],@needs.drop(1))
      else
        @closure.curry[object]
      end
    else
      self
    end
  end
end


class MyInt
  attr_reader :value
  
  def initialize(value)
    @value = value
  end
  
  def -
    needs = ["neg"]
    Closure.new(Proc.new {|b| MyInt.new(b.value - self.value)},needs)
  end
  
  def sum3 # checking whether currying works
    needs = ["neg","neg"]
    Closure.new(Proc.new {|b,c| MyInt.new(b.value + c.value + self.value)},needs)
  end
  
  def neg
    MyInt.new(-@value)
  end
  
  def grab(object)
    self
  end
  
  def needs
    []
  end
end

describe "partial application" do
  before(:each) do
    @minus = Closure.new(Proc.new {|arg| arg.-},["-"])
    @aa = MyInt.new(8)
    @bb = MyInt.new(5)
    @cc = @aa.-
    @dd = @aa.sum3
  end
  
  describe "closures" do
    it "should be possible to create an empty closure and have it grab its arg" do
      step_one = @minus.grab(@aa)
      step_one.should be_a_kind_of(Closure)
      step_one.can_use?(@aa).should == true
      step_one.grab(@aa).value.should == 0
    end
    
    it "should create a closure when you send #- to a MyInt instance" do
      @cc.should be_a_kind_of(Closure)
    end
    
    it "should be able to check an object and determine whether it can use it" do
      @cc.can_use?(:foo).should == false
      @cc.can_use?(@bb).should == true
    end
    
    it "should have a #needs item associated with each argument" do
      @cc.needs.should == ["neg"]
    end
    
    it "does should be able to #grab an object and apply the Proc to it" do
      diff = @cc.grab(@bb)
      diff.needs.should == []
      diff.value.should == -3
    end

    it "should produce a curried Closure when one of two arguments is assigned" do
      @dd.can_use?(@bb).should == true
      @dd.needs.should == ["neg","neg"]
    end
    
    it "should spit out a non-Closure when all the args are assigned" do
      @dd.grab(@bb).should be_a_kind_of(Closure)
      @dd.grab(@bb).grab(@bb).should be_a_kind_of(MyInt)
      @dd.grab(@bb).grab(@bb).value.should == 18 # a+b+c = 8 + 5 + 5
    end
  end
end



