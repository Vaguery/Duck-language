require_relative './spec_helper'

describe "Boolean stack item" do
  describe "initialization" do
    it "should be parsed from 'true' or 'false', 'T' or 'F'" do
      DuckInterpreter.new("true").parse.queue[-1].should be_a_kind_of(Bool)
      DuckInterpreter.new("false").parse.queue[-1].value.should == false
    end
    
    it "shouldn't try to parse embedded words" do
      DuckInterpreter.new("betrue").parse.queue[-1].should_not be_a_kind_of(Bool)
      DuckInterpreter.new("falsely").parse.queue[-1].should_not be_a_kind_of(Bool)
      DuckInterpreter.new("This").parse.queue[-1].should_not be_a_kind_of(Bool)
      DuckInterpreter.new("7F").parse.queue[-1].should_not be_a_kind_of(Bool)
    end
  end
  
  describe "visualization" do
    it "should look like 'T' or 'F'" do
      DuckInterpreter.new("F true false T").run.stack.inspect.should ==
        "[F, T, F, T]"
    end
  end
end