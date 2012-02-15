#encoding: utf-8
require_relative '../../spec_helper'

describe "Message" do
  describe ":bind" do
    it "should be recognized by a Message object" do
      Message.recognized_messages.should include :bind
    end
    
    it "should create a new Variable, with the message value as its key" do
      d = Interpreter.new script:"foo bind"
      d.run
      d.contents.inspect.should == "[λ(foo.bind(?),[\"be\"])]"
    end
    
    it "should end up being bound to the new thing REGARDLESS of its other meaning(s)" do
      d = Interpreter.new script:"( 1 2 3 ( 4 5 6 ) ) bind - F -"
      d.run
      d.contents.inspect.should == "[F, :-=(1, 2, 3, (4, 5, 6)), (1, 2, 3, (4, 5, 6))]"
    end
    
    it "should be able to bind even another message" do
      d = Interpreter.new script:"foo bind bar baz bind baz bind foo"
      d.run
      d.contents.inspect.should == "[:baz=:foo=:bar, :bar=:foo=:bar]"
      # no, really, it totally should be that
    end
    
    it "should not play havoc with duck-typing by redefining common signals" do
      confused = Interpreter.new script:"> x - neg bind", binder:{x:int(-30)}
      lambda { confused.run }.should_not raise_error
      confused.run.inspect.should include "err:["
    end
    
    it "should return an Error if it binds to 'itself'" do
      recursive = Interpreter.new script:"+ bind +"
      recursive.run
      recursive.inspect.should_not include ":+=:+"
    end
  end
end
