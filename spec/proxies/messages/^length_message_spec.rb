#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  describe ":^length" do
    it "should be recognized by a Script item" do
      Proxy.recognized_messages.should include("^length".intern)
    end
    
    it "should produce the length of the Interpreter in which it appears" do
      i = interpreter(script:"^length", contents:('a'..'f').collect {|i| message(i)})
      i.run
      i.inspect.should ==  "[:a, :b, :c, :d, :e, :f, 6 :: :: «»]"
    end
  end
end
