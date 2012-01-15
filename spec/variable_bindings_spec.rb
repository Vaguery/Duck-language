require_relative './spec_helper'

describe "initialization" do
  
  describe "when creating an Interpreter" do
    it "should be possible to add an optional arg, a Hash of bindings" do
      lambda { DuckInterpreter.new("2 x +",{"x" => Int.new(12)}) }.should_not raise_error
    end
  end
  
  describe "when resetting an Interpreter" do
    it "should be possible to change bindings when resetting" do
      ducky = DuckInterpreter.new("2 x +",{"x" => Int.new(12)})
      ducky.reset("2 x +",{"x" => Int.new(1)})
      ducky.bindings["x"].value.should == 1
    end
    
    it "should reset any temporary bindings established while running the previous state" do
      ducky = DuckInterpreter.new("2 x +",{"x" => Int.new(12)})
      ducky.step
      ducky.bindings["foo"] = Message.new("bar")
      ducky.reset("2 x +")
      ducky.bindings["x"].value.should == 12
      ducky.bindings["foo"].should == nil
    end
  end
  
  describe "running scripts" do
    describe "parser" do
      it "should parse bindings as Messages" do
        ducky = DuckInterpreter.new("x +",{"x" => Int.new(12)})
        ducky.parse
        ducky.queue[-1].should be_a_kind_of(Message)
      end
    end
    
    describe "staging" do
      it "should treat binding Messages as with others" do
        ducky = DuckInterpreter.new("x +",{"x" => Int.new(12)})
        ducky.should_receive(:fill_staged_item_needs)
        ducky.should_receive(:consume_staged_item_as_arg)
        ducky.step
      end
      
      it "should look up the binding (and recognize it) after the normal negotiations are done" do
        ducky = DuckInterpreter.new("x +",{"x" => Int.new(12)})
        ducky.bindings["x"].value.should == 12
        ducky.queue.should_receive(:unshift)
        ducky.run
      end
      
      it "should produce the thing bound" do
        ducky = DuckInterpreter.new("x x +",{"x" => Int.new(3)})
        ducky.run
        ducky.stack[-1].value.should == 6
      end
      
      it "should be flexible enough to handle bindings changed after initialization" do
        ducky = DuckInterpreter.new("x x +",{"x" => Int.new(3)})
        ducky.step
        ducky.bindings["x"] = Int.new(77)
        ducky.run
        ducky.stack[-1].value.should == 80
      end
      
      it "should work for quite complex bindings" do
        ducky = DuckInterpreter.new("x op 2",{"x" => Int.new(3),"op" => Message.new("+")})
        ducky.run
        ducky.stack[-1].value.should == 5
      end
    end
  end
end