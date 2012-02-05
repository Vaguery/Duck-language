require_relative '../spec_helper'

describe "Message object" do
  describe "initialization" do
    it "should be a subclass of Closure" do
      Message.new("foo").should be_a_kind_of(Closure)
    end
    
    it "should work if the message happens to be a Symbol rather than a String" do
      Message.new(:foo).value.should == Message.new("foo").value
    end
    
    it "should record the initialization string as its #needs item" do
      Message.new("foo").needs.should == ["foo"]
    end
    
    it "should have a closure that causes the 'arg' to call its string" do
      arg = Int.new(11)
      arg.should_receive("+")
      Message.new("+").closure.curry[arg]
    end
  end
  
  
  describe "message checking isolation" do
    it "should not allow stack items to respond to Ruby messages" do
      overflow = DuckInterpreter.new("2 object_id").run
      overflow.stack[-1].should_not be_a_kind_of(Fixnum) #meaning it has returned its object_id
      
      duper = DuckInterpreter.new("2 clone").run
      duper.stack[-1].should be_a_kind_of(Message)
      duper.stack[-1].value.should == :clone
    end
    
    it "should call Item#recognize_message?" do
      fooer = DuckInterpreter.new("2 foo").step
      fooer.stack[-1].should_receive(:recognize_message?).with("foo")
      fooer.step
    end
  end
  
  
  describe "visualization" do
    it "should look like a Ruby symbol" do
      DuckInterpreter.new("foo bar baz").run.stack.inspect.should == "[:foo, :bar, :baz]"
    end
  end
end