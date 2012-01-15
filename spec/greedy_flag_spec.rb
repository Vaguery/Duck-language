#encoding: utf-8
require_relative './spec_helper'

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
  
  describe "Duck script access" do
    it "should be readable in a script via the :greedy? message" do
      d = DuckInterpreter.new("greedy?").run
      d.stack.inspect.should == "[T]"
    end
    
    it "should be set to true by the :greedy message" do
      d = DuckInterpreter.new("greedy")
      d.greedy_flag = false
      d.run
      d.greedy_flag.should == true
    end
    
    it "should be set to false by the :ungreedy message" do
      d = DuckInterpreter.new("ungreedy")
      d.run
      d.greedy_flag.should == false
    end
  end
end