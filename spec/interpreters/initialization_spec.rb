require 'spec_helper'


describe "new Duck interpreter" do
  describe "created with no arguments" do
    it "should have an empty Script" do
      DuckInterpreter.new.script == ""
    end
  end
  
  describe "created with a script" do
    it "should strip whitespace from the ends of the script" do
      DuckInterpreter.new("   foo   ").script.should == "foo"
    end
    
    it "should totally disappear whitespace-only scripts" do
      DuckInterpreter.new("\t\t \n\r  ").script.should == ""
    end
  end
end

describe "resetting an Interpreter" do
  it "should reset all the initial settings" do
    old = DuckInterpreter.new("1 2 3 1 4 1 foo bar").run
    old.script.should == ""
    old.stack.length.should == 8
    old.queue.length.should == 0
    old.staged_item.should == nil

    old.reset("new script")
    old.script.should == "new script"
    old.stack.length.should == 0
    old.queue.length.should == 0
    old.staged_item.should == nil
  end
  
  it "should default to resetting to the original state" do
    starting_script = "1 2 3 1 4 1 foo bar"
    old = DuckInterpreter.new(starting_script).run
    old.script.should == ""
    old.reset
    old.script.should == starting_script
  end
end