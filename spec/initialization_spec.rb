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