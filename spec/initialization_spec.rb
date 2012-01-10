require 'spec_helper'


describe "new Duck interpreter" do
  describe "created with no arguments" do
    it "should have an empty Script" do
      DuckInterpreter.new.script == ""
    end
  end
end