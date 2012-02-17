require_relative '../spec_helper'

describe "Local" do
  describe "initialization" do
    it "should be something like a Message" do
      Local.new("_foo").should be_a_kind_of(Message)
      Local.new("_foo").value.should == :_foo
    end
    
    it "should raise an exception if you initialize it with a string that doesn't have an initial _" do
      lambda { Local.new("foo") }.should raise_error
    end
    
    it "should work inside scripts" do
      i = interpreter(script:"foo _foo").run
      i.contents[0].should_not be_a_kind_of(Local)
      i.contents[1].should be_a_kind_of(Local)
    end
  end
end