#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "step" do
    it "should be recognized by Iterator items" do
      Iterator.recognized_messages.should include :step
    end
    
    it "should return JUST itself if the index is outside the range, resetting the index to the close end" do
      askew = Iterator.new(start:0, end:3, index:9)
      askew.step.should == askew
      askew.index.should == 3
      
      askew = Iterator.new(start:0, end:3, index:-9)
      askew.step.should == askew
      askew.index.should == 0
    end
    
    describe "the :response mode" do
      context ":response => :contents" do
        it "should add the inc to the index and return itself and its contents" do
          four_threes = Iterator.new(start:0, end:3, contents:[int(3), int(4)])
          four_threes.step.inspect.should == "[(0..1..3)=>[3, 4], 3, 4]"
          four_threes.step.inspect.should == "[(0..2..3)=>[3, 4], 3, 4]"
          four_threes.step.inspect.should == "[(0..3..3)=>[3, 4], 3, 4]"
          four_threes.step.inspect.should == "(0..3..3)=>[3, 4]"
        end
      end
      
      context ":response => :element" do
        before(:each) do
          @nums = Iterator.new(start:0, end:6, contents:[int(1),int(2),int(3),int(4)],:response => :element)
        end
        
        it "should add the inc to the index and return itself and the idx element of its contents" do
          @nums.step.inspect.should == "[(0..1..6)=>[1, 2, 3, 4], 1]"
        end
        
        it "should use the index modulo the number of contents elements" do
          @nums.step.inspect.should == "[(0..1..6)=>[1, 2, 3, 4], 1]"
          @nums.step.inspect.should == "[(0..2..6)=>[1, 2, 3, 4], 2]"
          @nums.step.inspect.should == "[(0..3..6)=>[1, 2, 3, 4], 3]"
          @nums.step.inspect.should == "[(0..4..6)=>[1, 2, 3, 4], 4]"
          @nums.step.inspect.should == "[(0..5..6)=>[1, 2, 3, 4], 1]"
        end
        
        it "should work 'the same way' for Decimal spans" do
          odd = Iterator.new(start:-3.4, end:17.3, inc:1.1, contents:[message(:a), message(:b)], :response => :element)
          odd.step.inspect.should == "[(-3.4..~(-2.3)..17.3)=>[:a, :b], :a]"
          odd.step.inspect.should == "[(-3.4..~(-1.2)..17.3)=>[:a, :b], :b]"
          odd.step.inspect.should == "[(-3.4..~(-0.1)..17.3)=>[:a, :b], :a]"
          odd.step.inspect.should == "[(-3.4..~(1.0)..17.3)=>[:a, :b], :b]"
        end
        
        it "should work for empty contents" do
          nothin = Iterator.new(end:3, contents:[], :response => :element)
          lambda{ nothin.step }.should_not raise_error
          nothin.step.inspect.should == "[(0..2..3)=>[]]"
        end
      end
    end
    
    
    describe "the index_only flag" do
      it "should just return the (pre-update) index, not any elements of the contents" do
        counter = Iterator.new(start:-12,end:3,:response => :index)
        counter.step.inspect.should == "[(-12..-11..3)=>[], -12]"
        counter.step.inspect.should == "[(-12..-10..3)=>[], -11]"
      end
      
      it "should work for floating-point ranges" do
        ranger = Iterator.new(start:0.113,end:3.112,inc:2.2,:response => :index)
        ranger.step.inspect.should == "[(0.113..~(2.313)..3.112)=>[], 0.113]"
        ranger.step.inspect.should == "[(0.113..~(4.513)..3.112)=>[], 2.313]"
        ranger.step.inspect.should == "(0.113..~(3.112)..3.112)=>[]" # done
      end
    end
    
    it "should detect when the sign of the inc and the order of extremes needs changing" do
      down = Iterator.new(start:10, end:3, index:7, contents:[bool(F)])
      down.step.inspect.should == "[(10..6..3)=>[F], F]"
      
      down = Iterator.new(start:10, end:3, inc:-2, contents:[bool(F)])
      down.step.inspect.should == "[(10..8..3)=>[F], F]"
      
      down = Iterator.new(start:10.0, end:3.1, inc:-3.1, contents:[bool(F)])
      down.step.inspect.should == "[(10.0..~(6.9)..3.1)=>[F], F]"
    end
    
    
    it "should return an Array containing just itself (updated) if nothing is bound" do
      four_threes = Iterator.new(start:0, end:3)
      four_threes.step.inspect.should == "[(0..1..3)=>[]]"
      four_threes.step.inspect.should == "[(0..2..3)=>[]]"
      four_threes.step.inspect.should == "[(0..3..3)=>[]]"
      four_threes.step.inspect.should == "(0..3..3)=>[]"
      four_threes.step.inspect.should == "(0..3..3)=>[]"
    end
  end
end
