#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  describe ":^greedy=" do
    it "should be recognized by an Proxy item" do
      Proxy.recognized_messages.should include("^greedy=".intern)
    end
    
    it "should produce a Closure looking for a Bool" do
      i = interpreter(script:"^greedy=").run
      i.contents[0].should be_a_kind_of(Closure)
      i.contents[0].needs.should == ["¬"]
    end
    
    it "should change the Interpreter greedy_flag" do
      i = interpreter(script:"^greedy= F")
      i.greedy_flag.should == true
      i.run
      i.greedy_flag.should == false
    end
  end
end
