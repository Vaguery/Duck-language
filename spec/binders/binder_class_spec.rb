#encoding:utf-8
require_relative '../spec_helper'

describe "Binder class" do
  it "is a kind of List" do
    Binder.new.should be_a_kind_of(List)
  end
  
  describe "initialization" do
    it "should be possible to initialize it with an array of contents" do
      two_things = Binder.new([int(9), bool(F)])
      two_things.contents.length.should == 2
      two_things.contents[0].value.should == 9
    end
  end
  
  describe ":from_key_value_hash" do
    it "should be possible to pass in a Hash of key/value pairs" do
      b = Binder.from_key_value_hash(x:int(9), y:bool(F))
      b.contents.length.should == 2
      b.contents.each {|item| item.should be_a_kind_of(Variable)}
    end
    
    it "should raise an exception if one of the keys is not a Symbol or String" do
      lambda { Binder.from_key_value_hash(12 => int(9)) }.should raise_error(ArgumentError)
      lambda { Binder.from_key_value_hash([:y] => bool(F)) }.should raise_error(ArgumentError)
    end
    
    it "should raise an exception if one of the values is not a single Duck item" do
      lambda { Binder.from_key_value_hash(:x => 12) }.should raise_error(ArgumentError)
      lambda { Binder.from_key_value_hash(:y => [bool(F)]) }.should raise_error(ArgumentError)
    end
  end
  
  describe "behavior" do
    before(:each) do
      @two_things = Binder.new([int(9), bool(F)])
    end
    
    it "should 'recognize' (in the Duck sense) messages if any of its contents respond" do
      @two_things.recognize_message?("¬").should == true
      @two_things.recognize_message?("foo").should == false
      @two_things.recognize_message?("length").should == true  # Binder itself, via inheritance
    end
    
    it "should work in the #can_use? form as well" do
      message("*").can_use?(Binder.new([int(3)])).should == true
    end
    
    it "should #personally_recognizes? messages its contents DO NOT respond to but it does" do
      @two_things.personally_recognizes?("length").should == true
      @two_things.personally_recognizes?("¬").should == false
      @two_things.personally_recognizes?("+").should == false
      
    end
    
    it "should return what you get tracing the path to an item inside it that recognizes a message" do
      @two_things.produce_respondent("¬").should be_a_kind_of(Bool)
      @two_things.produce_respondent("¬").inspect.should == "F"
    end
    
    it "should be consumed if it responded itself to the message" do
      @two_things.personally_recognizes?("length").should == true
      @two_things.produce_respondent("length").should == @two_things
    end
    
    it "should work in situ" do
      d = interpreter(script:"length",contents:[Binder.new()])
      d.run
      d.inspect.should == "[0 :: :: «»]"
      
      d = interpreter(script:"* - - - * * + length ",contents:[Binder.new([int(8)])])
      d.run
      d.inspect.should == "[-3576, 1 :: :: «»]"
    end
  end

  
  describe "nested Binders" do
    it "should return the internal binder before returning itself" do
      two_things = Binder.new([int(9), bool(F)])
      and_one_more = Binder.new([two_things])
      interpreter(script:"shatter", contents:[and_one_more]).run.inspect.should ==
        "[{{9, F}}, 9, F :: :: «»]"
    end
    
    it "should recognize a message even when an item INSIDE a nested Binder does so" do
      nested = Binder.new([Binder.new([int(9)])])
      nested.contains_an_arg_for?(message(:neg)).should == true
    end
    
    it "should respond with the entire (depth-first) tree to the responding item" do
      nested = Binder.new([Binder.new([int(9)])])
      lots_of_responses = interpreter(contents:[nested], script:"neg").run
      lots_of_responses.inspect.should == "[{{9}}, -9 :: :: «»]"
    end
  end
  
  describe "visualization" do
    it "should appear in curly braces" do
      Binder.new([int(0), bool(F)]).to_s.should == "{0, F}"
    end
  end
end