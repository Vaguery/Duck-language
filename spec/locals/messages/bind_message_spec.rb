#encoding: utf-8
require_relative '../../spec_helper'

describe "Message" do
  describe ":bind" do
    it "should be recognized by a Message object" do
      Local.recognized_messages.should include :bind
    end
    
    it "should create a new Variable, with the message value as its key" do
      d = Interpreter.new script:"_foo bind"
      d.run
      d.contents.inspect.should == "[λ(_foo.bind(?),[\"be\"])]"
    end
    
    it "should end up being bound to the new thing REGARDLESS of its other meaning(s)" do
      d = Interpreter.new script:"( 1 2 3 ( 4 5 6 ) ) bind _foo F _foo"
      d.run
      d.contents.inspect.should == "[F, :_foo=(1, 2, 3, (4, 5, 6)), (1, 2, 3, (4, 5, 6))]"
    end
    
    it "should be able to bind even another Local" do
      d = Interpreter.new script:"_foo bind _bar _baz bind _baz bind _foo"
      d.run
      d.inspect.should ==  "[:_baz=:_foo=:_bar, :_bar=:_foo=:_bar :: :: «»]"
      # no, really, it totally should be that
    end
    
    it "should not play havoc with duck-typing by redefining a nonLocal Message" do
      unconfused = interpreter(script:"x bind 8", binder:{x:int(2)}) 
      unconfused.run.inspect.should_not include(":x=8")
      
      unconfused = interpreter(script:"x bind 8 _x", binder:{x:int(2)}) 
      unconfused.run.inspect.should == "[:x=2, 2, :_x=8 :: :: «»]"
    end
    
    it "should return an Error if it binds to 'itself'" do
      recursive = Interpreter.new script:"_arg bind _arg"
      recursive.run.inspect.should == "[err:[RECURSIVE VARIABLE] :: :: «»]"
    end
  end
end
