#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  before(:each) do
    @easy_version = "^flush".intern
  end
  
  describe ":^flush" do
    it "should be recognized by a Proxy item" do
      Proxy.recognized_messages.should include(@easy_version)
    end
    
    it "should set halted=true" do
      interpreter(script:"1 2 ^flush a b c").run.halted.should == true
    end
    
    it "should immediately flush the buffer into a List" do
      interpreter(buffer:[message("^flush".intern), int(1), int(2)]).run.inspect.should == 
        "[(1, 2), «» :: :: «»]"
    end
    
    it "should flush the script onto the contents" do
      interpreter(script:"1 2 ^flush a b c").run.inspect.should ==
        "[1, 2, (), «a b c» :: :: «»]"
    end
  end
end
