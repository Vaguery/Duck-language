#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "times_do" do
    it "should be recognized by Int items" do
      Int.recognized_messages.should include :times_do
    end
    
    it "should return a Closure looking for any Item" do
      int(8).times_do.should be_a_kind_of(Closure)
      int(8).times_do.needs.should == ["be"]
    end
    
    it "should produce running Iterator" do
      interpreter(script:"9.2 1 times_do").run.inspect.should == "[9.2, (0..1..1)=>[9.2] :: :: «»]"
    end
    
    it "should also produce the expected results" do
      interpreter(script:"F 4 times_do").run.inspect.should == "[F, F, F, F, (0..4..4)=>[F] :: :: «»]"
    end
  end
end
