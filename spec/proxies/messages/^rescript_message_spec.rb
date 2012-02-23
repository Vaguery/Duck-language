#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  before(:each) do
    @easy_version = "^rescript".intern
  end
  
  describe ":^rescript" do
    it "should be recognized by a Script item" do
      Proxy.recognized_messages.should include(@easy_version)
    end
    
    it "should produce a Closure looking for a string" do
      looking = Proxy.new(interpreter).send(@easy_version)
      looking.should be_a_kind_of(Closure)
      looking.needs.should == ["lowercase"]
    end
    
    it "should be recognizable if the arg isn't found" do
      interpreter(script:"^rescript a").run.inspect.should ==
        "[λ(<SCRIPT>.prepend(?),[\"lowercase\"]), :a :: :: «»]"
    end
    
    it "should prepend the arg script to the running script" do
      quoted = interpreter(script:"4 ^quote a b c d 3 copies ^rescript").run
      quoted.inspect.should == "[«a b c d», «a b c d», :a, :b, :c, :d :: :: «»]"
    end
    
    it "should work with empty scripts" do
      interpreter(script:"0 ^quote ^rescript 8").run.inspect.should == "[8 :: :: «»]"
    end
    
    it "should return an Error if the result would be more than 32k characters long" do
      toolong = interpreter(script:"^rescript 1234567890", contents:[Script.new("x"*40000)])
      toolong.run.inspect.should == "[err:[OVERSIZED SCRIPT], 1234567890 :: :: «»]"
    end
  end
end
