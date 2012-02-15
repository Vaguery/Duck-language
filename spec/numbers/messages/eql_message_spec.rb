#encoding: utf-8
require_relative '../../spec_helper'

describe "Number" do
  describe "==" do
    it "should return the appropriate Bool for two Numbers" do
      interpreter(script:"2 1 eql").run.contents[-1].value.should == false
      interpreter(script:"1 2 eql").run.contents[-1].value.should == false
      interpreter(script:"1 1 eql").run.contents[-1].value.should == true
    end
  end
end
