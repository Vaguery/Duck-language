#encoding: utf-8
require_relative '../spec_helper'

describe "initialization" do
  
  it "should have a #closure attribute, which is a Proc" do
    Closure.new {:foo}.closure.call.should == :foo
  end
  
  it "should have an array of #needs" do
    Closure.new(["bar"]) {:foo}.needs.should == ["bar"]
  end
  
  it "should accept an optional #string_value" do
    Closure.new([],"HI THERE") {:foo}.string_version.should == "HI THERE"
  end
  
  it "should have a Duck shortcut" do
    closure {}.should be_a_kind_of(Closure)
    closure(["bar"]) {}.needs.should == ["bar"]
  end
end


describe "grabbing and consuming arguments" do
  describe "grab" do
    class Fooer < Item
      def foo
        :bar
      end
      @recognized_messages = self.instance_methods(false) # to keep from inheriting Item's messages
    end
    
    it "should return itself when the object it tries to grab doesn't respond to the 1st need" do
      bad_match = closure(["foo"]) {:foo}
      bad_match.grab(int(88)).should == bad_match
    end
    
    it "should return a modified closure if it grabs successfully" do
      good_match = closure(["foo"]) {:foo}
      good_match.grab(Fooer.new(1)).should_not == good_match
    end
    
    it "should actually grab the thing" do
      negater = closure(["inc"]) {|int| int(-int.value.to_i)}
      negater.grab(int(12)).inspect.should == "-12"
      negater.grab(negater.grab(int(12))).value.should == 12
    end
    
    it "should work for closures requiring multiple arguments" do
      add_three_er = closure(["inc", "inc", "inc"]) do |i1, i2, i3|
        int(i1.value.to_i + i2.value.to_i + i3.value.to_i)
      end
      int_1 = int(1)
      int_2 = int(10)
      int_3 = int(100)
      
      step_1 = add_three_er.grab(int_1)
      step_1.to_s.should == "λ(f(_,_),[\"inc\", \"inc\"])"
      
      step_2 = step_1.grab(int_2)
      step_2.inspect.should == 'λ(f(_),["inc"])'
      
      stacked =  add_three_er.closure.curry[int_1]
      stacked = stacked.curry[int_2]
      stacked = stacked.curry[int_3]
      step_3 = step_2.grab(int_3)
      step_3.class.should == Int
    end
  end
  
  describe "various edge cases of grabbing which have cropped up" do
    it "should produce a Closure when a 2-arity Closure is an arg of List#map" do
      tricky = interpreter(script:"[]= map", contents:[list([int(3), int(5)]), list([bool(F)])])
      tricky.run
      tricky.contents[0].contents.each {|item| item.should be_a_kind_of(Closure)}
    end
  end
  
  describe "creating Error objects for failure conditions" do
    it "should create an Error when a TypeError arises" do
      misleader = variable("neg", message("-"))
      oh_boy = interpreter(script:"9 +", contents:[misleader])
      oh_boy.run.inspect.should =~ /err:\[/
    end
    
    it "should create an Error when a NoMethodError arises" do
      misleader = variable("neg", message("ungreedy"))
      oh_boy = interpreter(script:"-9.9 +", contents:[misleader])
      oh_boy.run.inspect.should =~ /err:\[/
    end
  end
end

describe "grabbing Binder items" do
  it "should recognize that it has grabbed a Binder" do
    int_negater = closure(["inc"]) {|int| int(-int.value.to_i)}
    contains_a_number = Binder.new([int(12)]) # the Int responds, not the binder
    int_negater.grab(contains_a_number).should be_a_kind_of(Array)
  end
  
  it "should return a flat Array, which includes the Binder as the first element, even for Array results" do
    blowup = closure(["shatter"]) {|list| list.contents}
    contains_a_list = Binder.new([list([int(1), int(2)])])
    blowup.grab(contains_a_list).inspect.should == "[{(1, 2)}, 1, 2]" # flattened array of results
  end
end


describe "deep_copy" do
  it "should copy all the parts" do
    old = Closure.new(["foo"],"string") {|i| i}
    old.closure.call(8).should == 8
    
    copy = old.deep_copy
    
    copy.inspect.should == old.inspect
    copy.closure.object_id.should_not == old.closure.object_id
  end
end


describe "value" do
  it "should be the string representation" do
    c = closure(["foo","bar","bar","baz"]) {|a,b,c,d| (a+b).collect(c).filter(d)}
    c.value.should == c.to_s
  end
end


describe "string representation" do
  before(:each) do
    @simple = closure(["bar"]) {|a| a}
    @complicated = closure(["foo","bar","bar","baz"]) {|a,b,c,d| (a+b).collect(c).filter(d)}
  end
  
  it "should say it's a closure" do
    @simple.to_s.should =~ /λ\(.*\)/
    @complicated.to_s.should =~ /λ\(.*\)/
  end
  
  it "should say what it needs" do
    @simple.to_s.should =~ /"bar"/
    @complicated.to_s.should =~ /"foo",\s*"bar",\s*"bar",\s*"baz"/
  end
  
  it "should default to saying something about the number of args in the Proc" do
    closure(["bar"]) {|a| a}.to_s.should =~
      /f\(_\)/
  end
  
  it "should be able to show something to indicate the method call" do
    annotated = closure(["bar","baz"],"arg1 + 2*arg2") {|a,b| a+2*b}
    annotated.to_s.should include "arg1 + 2*arg2"
  end
end