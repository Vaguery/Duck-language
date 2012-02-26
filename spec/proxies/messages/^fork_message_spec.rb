#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  before(:each) do
    @easy_version = "^fork".intern
  end
  
  describe ":^fork" do
    it "should be recognized by a Proxy item" do
      Proxy.recognized_messages.should include(@easy_version)
    end
    
    it "should produce a deep_copy of the running Interpreter, preceded by a :run message" do
      interpreter(script:"1 2 ^fork a b c").run.inspect.should == 
        "[1, 2, [1, 2, :a, :b, :c :: :: «»], :a, :b, :c :: :: «»]"
    end
    
    it "should NOT be the actual interpreter being forked, but a copy" do
      meta = interpreter(script:"^fork").run
      meta.object_id.should_not == meta.contents[0].object_id
    end
    
    it "should not contain a proxy to the outer Interpreter" do
      meta = interpreter(script:"^fork").run
      meta.proxy.details.should_not == meta.contents[0].proxy.details
    end
    
    it "should have half the current Interpreter's max_ticks" do
      base = interpreter(script:"^fork foo").run
      base.max_ticks.should == 6000
      base.contents[0].max_ticks.should == 3000
    end
  end
end
