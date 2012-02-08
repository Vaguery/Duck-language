#encoding:utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :[]= message for Lists" do
    before(:each) do
      @msg = "[]=".intern
    end

    it "should be something Lists recognize" do
      List.recognized_messages.should include(@msg)
    end
    
    it "should produce a Closure" do
      List.new.send(@msg).should be_a_kind_of(Closure)
    end

    it "the Closure should 'need' two items, that respond to 'inc' and 'be'" do
      wanting = List.new.send(@msg)
      wanting.needs.should == ["inc","be"]
    end
    
    it "should grab an Int as its first argument" do
      d = Interpreter.new("( 1 ) 0 []=").run
      d.contents[-1].needs.should == ["be"]
    end
    
    it "should then grab some other thing to stick into the List" do
      d = Interpreter.new("( 1 2 3 4 ) 0 F []=").run
      d.inspect.should == ""
    end


    it "should replace the nth element of the List with the new item" do
      pending
      d = DuckInterpreter.new("( 1 2 3 4 ) 9 1 []=").run
      d.stack.inspect.should == "[(1, 9, 3, 4)]"
    end

    it "should work with negative integers" do
      pending
      d = DuckInterpreter.new("( 1 2 3 4 ) 9 -2 []=").run
      d.stack.inspect.should == "[(1, 2, 9, 4)]"
    end

    it "should work with large positive integers" do
      pending
      d = DuckInterpreter.new("( 1 2 3 4 ) 9 12 []=").run
      d.stack.inspect.should == "[(9, 2, 3, 4)]"
    end

    it "should work with an empty List" do
      pending
      d = DuckInterpreter.new("( ) 9 12 []=").run
      d.stack.inspect.should == "[(9)]"
    end
  end

  describe "ensuring some bugs don't crop up" do
    it "should not have a problem with Script 1" do
      pending
      d = DuckInterpreter.new("x ungreedy T * ∨ ≤ -5 3 reverse -9.672 push 6.572 zap unshift F x -0.809 + F x known ≥ 2 x pop -8 5 trunc x x dec x < 0.001 unshift x -7 -2 ungreedy x x x trunc x ) ≤ zap ) []= pop T x -6.37 -0.367 -5 0 -1.071 x 1.701 if shatter x ∧ x inc []= ungreedy inc T 3 T x -1 ≥ trunc F x x neg ∨ 7 F x 1 x neg -9 unshift -4 6 x zap -6 [] 9 x know? pop reverse x reverse F -2 x + T T T x ≥ F x -5 x -5.835 ∨ + < ¬ ( x -9 T do greedy? copy F -5 pop T pop x if quote copy F -1 [] unshift ∧ T x pop x F x known x known quote shatter if x unshift -7 F quote T unshift quote 1 ( 1.564 x -6 -2 reverse greedy dec -7 -8.292 T x swap -4 greedy? x be [] -9 greedy? F -8.569 depth T copy ) F ≥ if push ∧ if neg 7 - < 7.645 F -4.694", {"x" =>[Int.new(12),Int.new(13)]})

      lambda { d.run }.should_not raise_error
    end
  end
end
