require_relative '../spec_helper'

describe "Message object" do
  describe "initialization" do
    it "should be a subclass of Closure" do
      Message.new("foo").should be_a_kind_of(Closure)
    end
    
    it "should have a Duck shortcut" do
      message("foo").should be_a_kind_of(Message)
      message("foo").value.should == :foo
    end
    
    
    it "should work if the message happens to be a Symbol rather than a String" do
      message(:foo).value.should == message("foo").value
    end
    
    it "should record the initialization string as its #needs item" do
      message("foo").needs.should == ["foo"]
    end
    
    it "should have a closure that causes the 'arg' to call its string" do
      arg = int(11)
      arg.should_receive("+")
      message("+").closure.curry[arg]
    end
    
  end
  
  describe "acting on a Binder" do
    it "should return a flat Array, which includes the Binder as the first element, even for Array results" do
      blowup = message("shatter")
      contains_a_list = Binder.new([list([int(1), int(2), List.new])])
      blowup.grab(contains_a_list).inspect.should == "[{(1, 2, ())}, 1, 2, ()]" # flattened array of results
    end
    
  end
  
  
  describe "message checking isolation" do
    it "should not allow stack items to respond to Ruby messages" do
      overflow = interpreter(script:"2 object_id").run
      overflow.contents[-1].should_not be_a_kind_of(Fixnum) #meaning it has returned its object_id
      
      duper = interpreter(script:"2 clone").run
      duper.contents[-1].should be_a_kind_of(Message)
      duper.contents[-1].value.should == :clone
    end
    
    it "should call Item#recognize_message?" do
      fooer = interpreter(script:"foo",contents:[int(2)])
      fooer.contents[-1].should_receive(:recognize_message?).with("foo")
      fooer.run
    end
  end
  
  
  describe "visualization" do
    it "should look like a Ruby symbol" do
      interpreter(script:"foo bar baz").run.contents.inspect.should == "[:foo, :bar, :baz]"
    end
  end
end