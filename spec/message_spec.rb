require_relative './spec_helper'

describe "Message object" do
  describe "initialization" do
    it "should be a subclass of Closure" do
      Message.new("foo").should be_a_kind_of(Closure)
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
  
  describe "visualization" do
    it "should look like a Ruby symbol" do
      Message.new("foo").to_s.should == ":foo"
    end
  end
end