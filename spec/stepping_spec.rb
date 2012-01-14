require_relative './spec_helper'

describe "interpreter step" do
  describe "parsing" do
    before(:each) do
      @ducky = DuckInterpreter.new("1 2 + foo")
    end
    
    it "should be possible to nest stepping" do
      lambda { @ducky.step.step }.should_not raise_error
    end
    
    
    describe "parsing" do
      it "should parse the next substring off the script" do
        @ducky.step
        @ducky.script.should == "2 + foo"
      end

      it "should recognize the token it grabs" do
        @ducky.should_receive(:recognize).with("1")
        @ducky.step
      end

      it "should push the recognized item onto the queue" do
        @ducky.stub(:recognize).and_return("a string")
        @ducky.queue.should_receive(:push).with("a string")
        @ducky.step
      end
      
      it "should be possible to nest parsing" do
        lambda { @ducky.parse.parse }.should_not raise_error
      end
    end
    
    describe "queue" do
      it "should remove the lowest queued item" do
        @ducky.queue.should_receive(:delete_at).with(0)
        @ducky.step
      end

      it "should still change queue state even when the script is empty, if there are queued items" do
        @ducky.script = ""
        @ducky.queue.push(Int.new(7))
        @ducky.step
        @ducky.queue.length.should == 0
        @ducky.stack[-1].value.should == 7
      end

      it "should only parse a script token if there's nothing in the queue" do
        @ducky.queue.push(Int.new(7))
        @ducky.should_not_receive(:parse)
        @ducky.step
      end
    end
    
    
    describe "staging" do
      it "should only stage and handle the oldest queue item" do
        @ducky.queue.push(Int.new(7))
        @ducky.queue.push(Int.new(8))
        @ducky.step
        @ducky.stack[-1].value.should == 7
      end

      it "should check the staged item's needs against the stack items" do
        @ducky.should_receive(:fill_staged_item_needs)
        @ducky.step
      end

      it "should UPDATE the staged item with the result of filling its need" do
        @ducky.step.step # puts the two integers onto tke stack
        @ducky.step
        @ducky.stack[-1].value.should == 3 # result "+(2)(1)" -> 3
      end

      it "should DELETE the args it pulls out of the stack when it fills the staged item's needs" do
        @ducky.step.step # puts the two integers onto tke stack
        @ducky.step
        @ducky.stack.length.should == 1
      end

      it "should present the staged item to the stack items to see if it fills any of their needs" do
        @ducky.step
        @ducky.parse # preps the next token
        the_2 = @ducky.queue[-1]
        @ducky.stack[-1].should_receive(:can_use?).with(the_2).and_return(false)
        @ducky.step
      end

      it "should consume the staged item to update a stack item if it is useful to it" do
        @ducky.script = "+ 1"
        @ducky.step # pushes the closure onto the stack
        @ducky.stack.should_receive(:delete_at).with(0)
        @ducky.step
      end
      
      it "should consume the topmost staged item to update a stack item if it is useful to it" do
        @ducky.script = "+ + 1"
        @ducky.step.step # pushes two closures
        @ducky.stack.should_receive(:delete_at).with(1)
        @ducky.step
      end
      
      it "should end up placing the result of being used as an argument at the BOTTOM of the queue" do
        @ducky.script = "+ + 1"
        @ducky.step.step # pushes two closures
        @ducky.step
        @ducky.queue.length.should == 1
        @ducky.queue[0].should be_a_kind_of(Closure)
      end
      
      it "should clear the staged_item when it's done" do
        @ducky.script = "2"
        @ducky.step
        @ducky.staged_item.should == nil
      end
    end
  end
end