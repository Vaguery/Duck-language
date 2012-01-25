#encoding: utf-8
require_relative './spec_helper'

describe "the :messages message for Stack Items" do
  it "should be something Items recognize" do
    Item.new.should respond_to(:known)
  end
  
  it "should produce a Bundle" do
    Item.new.known.should be_a_kind_of(Bundle)
  end
  
  it "should contain Messages" do
    Item.new.known.contents.each do |msg|
      msg.should be_a_kind_of(Message)
    end
  end
  
  it "should contain one Message for every thing the Item knows" do
    Item.new.known.contents.length.should == Item.recognized_messages.length
    Item.new.known.contents.each do |msg|
      Item.recognized_messages.should include(msg.value)
    end
  end
  
  it "should work for other subclasses of Item as expected" do
    Int.new.known.contents.length.should == Int.recognized_messages.length
    Bundle.new.known.contents.length.should == Bundle.recognized_messages.length
    Closure.new(Proc.new {},[]).known.contents.length.should == Closure.recognized_messages.length
  end
end

describe "finicky bugs found" do
  it "should work in the previously buggy script" do
    d = DuckInterpreter.new("4 -7 shatter x x -3 known depth [] ) -5 ungreedy T x -6 know? x F T + greedy? quote pop quote x quote < -4 x reverse ≥ inc T x x x -7 swap ¬ - ungreedy -8 x if x")
    lambda do
      until d.script == ""
        d.step
        # puts "#{d.stack.inspect} << #{d.queue.inspect} << #{d.script.inspect}<br />\n"
      end
    end.should_not raise_error
    
    
    d = DuckInterpreter.new("T x T * depth greedy x 3 -10 swap zap pop ) -5 ∨ 6 quote x greedy? F 7 > < -8 ∧ pop x F x known depth if ≥ dec swap F neg if * shift shift F shatter ( 0 x - x ≤ -1 x ∧ ≥ T be")
    lambda do
      until d.script == ""
        d.step
        puts "#{d.stack.inspect} << #{d.queue.inspect} << #{d.script.inspect}<br />\n"
      end
    end.should_not raise_error
  end
end