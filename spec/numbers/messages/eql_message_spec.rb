#encoding: utf-8
require_relative '../../spec_helper'

describe "Number" do
  describe "==" do
    it "should return the appropriate Bool for two Numbers" do
      DuckInterpreter.new("2 1 eql").run.stack[-1].value.should == false
      DuckInterpreter.new("1 2 eql").run.stack[-1].value.should == false
      DuckInterpreter.new("1 1 eql").run.stack[-1].value.should == true
    end
  end
end