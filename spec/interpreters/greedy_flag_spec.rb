#encoding: utf-8
require_relative '../spec_helper'

describe "GREEDY interpreter flag" do
  it "should be ON in a default interpreter" do
    DuckInterpreter.new("foo").greedy_flag.should == true
  end
  
  it "should be resettable" do
     d = DuckInterpreter.new("foo")
     d.greedy_flag = false
     d.reset
     d.greedy_flag.should == true
  end
  
  describe "behavior" do
    it "should skip checking the staged item as an argument when set to false" do
      ungreedy = DuckInterpreter.new("+ 1 + 2 3")
      ungreedy.greedy_flag = false
      ungreedy.run
      ungreedy.stack.inspect.should == "[:+, λ(1 + ?,[\"neg\"]), 2, 3]"
      
      ungreedy.reset
      ungreedy.run
      ungreedy.stack.inspect.should == "[6]"
    end
  end
end