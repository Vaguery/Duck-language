#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  describe ":^script" do
    it "should be recognized by a Script item" do
      Proxy.recognized_messages.should include("^script".intern)
    end
    
    it "should produce the script of the Interpreter in which it appears" do
      i = interpreter(script:"^script foo bar baz", contents:[int(2)])
      i.run
      i.inspect.should ==  "[2, «foo bar baz», :foo, :bar, :baz :: :: «»]"
    end
    
    it "should not execute the script copy, of course" do
      i = interpreter(script:"^script 3 4 + *", contents:[int(2)])
      i.run
      i.inspect.should ==  "[«3 4 + *», 14 :: :: «»]"
    end
  end
end
