require_relative '../spec_helper'

describe "Integer stack item" do
  describe "initialization" do
    it "should save the value passed" do
      int(33).value.should == 33
    end
    
    it "should be a kind of Number" do
      int(33).should be_a_kind_of(Number)
    end
    
    it "should have a Duck helper method to simplify creation" do
      int(33).value.should == 33
      int(-912).value.should == -912
    end
    
  end
  
  describe "interpreting Int literals" do
    before(:each) do
      @ducky = interpreter(script:"123 -912")
    end

    it "should place the IntItem onto an empty stack when it's an Int" do
      @ducky.run
      @ducky.contents[0].should be_a_kind_of(Int)
      @ducky.contents[0].value.should == 123
    end
  end
  
  describe "visualization" do
    it "should look like the raw value" do
      interpreter(script:"-121 9912 33 1 0").run.contents.inspect.should ==
        "[-121, 9912, 33, 1, 0]"
    end
  end
end