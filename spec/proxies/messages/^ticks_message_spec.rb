#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  describe ":^ticks" do
    it "should be recognized by a Proxy item" do
      Proxy.recognized_messages.should include("^ticks".intern)
    end
    
    it "should produce the current tick count of the Interpreter in which it appears" do
      i = interpreter(script:"foo bar baz ^ticks")
      i.run
      i.inspect.should ==  "[:foo, :bar, :baz, 4 :: :: «»]"
    end
  end
end
