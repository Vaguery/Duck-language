#encoding: utf-8
require_relative '../../spec_helper'

describe "Message" do
  describe ":bind" do
    it "should be recognized by a Message object" do
      Message.recognized_messages.should include(:bind)
    end
    
    it "should create a new Variable, with the message value as its key" do
      d = DuckInterpreter.new("foo bind")
      d.run
      d.stack.inspect.should == "[λ(foo.bind(?),[\"be\"])]"
    end
    
    it "should end up being bound to the new thing REGARDLESS of its other meaning(s)" do
      d = DuckInterpreter.new("( 1 2 3 ( 4 5 6 ) ) bind - F -")
      d.run
      d.stack.inspect.should == "[F, :-=(1, 2, 3, (4, 5, 6)), (1, 2, 3, (4, 5, 6))]"
    end
    
    it "should be able to bind even another message" do
      d = DuckInterpreter.new("foo bind bar baz bind baz bind foo")
      d.run
      d.stack.inspect.should == "[:baz=:foo=:bar, :bar=:foo=:bar]"
      # no, really, it totally should be that
    end
  end
end
