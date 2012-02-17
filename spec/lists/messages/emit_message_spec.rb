#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :emit message for Lists" do
    it "should be recognized by Lists" do
      List.recognized_messages.should include(:emit)
    end
    
    it "should produce a Closure looking for a Message" do
      emitter = List.new.emit
      emitter.should be_a_kind_of(Closure)
      emitter.needs.should == ["do"]
    end
    
    it "should pop the topmost item that responds to that message" do
      numbers = list([int(1), int(2), int(3)])
      emit_it = interpreter(script:"inc emit", contents:[numbers]).run
      emit_it.inspect.should == "[(1, 2), 3 :: :: «»]"
    end
    
    it "should ignore intervening items that don't respond" do
      numbers_and_stuff = list([int(1), bool(F), decimal(1.3)])
      emit_it = interpreter(script:"inc emit", contents:[numbers_and_stuff]).run
      emit_it.inspect.should == "[(F, 1.3), 1 :: :: «»]"
    end
    
    it "should work with empty lists" do
      nuttin = list
      emit_it = interpreter(script:"inc emit", contents:[nuttin]).run
      emit_it.inspect.should == "[() :: :: «»]"
    end
    
    it "should work with lists that don't contain respondents" do
      ignoring_you = list([int(1), bool(F), decimal(1.3)])
      emit_it = interpreter(script:"foo emit", contents:[ignoring_you]).run
      emit_it.inspect.should == "[(1, F, 1.3) :: :: «»]"
    end
  end
end
