#encoding:utf-8
require_relative '../spec_helper'

describe "the Script class" do
  it "should be a subclass of item" do
    Script.new.should be_a_kind_of(Item)
  end
  
  it "should have a Duck shortcut" do
    script.should be_a_kind_of(Script)
    script("foo").value.should == "foo"
  end
  
  it "should have a @value" do
    Script.new.value.should == ""
    script("foo").value.should == "foo"
  end
  
  describe ":next_word" do
    it "should respond to :next_word by snipping off and returning its first word" do
      s = script("foo bar baz")
      s.next_word.should == "foo"
      s.inspect.should == "«bar baz»"
    end
    
    it "should work when there is leading space" do
      s = script(" \t\t\n foo bar baz")
      s.next_word.should == "foo"
      s.inspect.should == "«bar baz»"
    end
    
    it "should not fail when the script is empty" do
      s = Script.new
      s.next_word.should == ""
      s.inspect.should == "«»"
    end
  end
  
  describe ":next_token" do
    it "should snip off the next word and return a parsed Duck token" do
      s = script("foo 12.34 F")
      s.next_token.should be_a_kind_of(Message)
      s.inspect.should == "«12.34 F»"
      s.next_token.should be_a_kind_of(Decimal)
      s.inspect.should == "«F»"
      s.next_token.should be_a_kind_of(Bool)
      s.inspect.should == "«»"
      s.next_token.should == nil
      s.value.should == ""
    end
  end
  
  it "should be represented on the Stack as being in guillemets" do
    d = interpreter(script:"")
    d.buffer.push script("hi there")
    d.run
    d.contents.inspect.should == "[«hi there»]"
  end
end