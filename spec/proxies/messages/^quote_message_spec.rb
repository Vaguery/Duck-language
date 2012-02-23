#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  before(:each) do
    @easy_version = "^quote".intern
  end
  describe ":^quote" do
    it "should be recognized by a Script item" do
      Proxy.recognized_messages.should include("^quote".intern)
    end
    
    it "should produce a Closure looking for an int" do
      looking = Proxy.new(interpreter).send(@easy_version)
      looking.should be_a_kind_of(Closure)
      looking.needs.should == ["inc"]
    end
    
    it "should quote that many tokens' worth of text from the running script" do
      quoted = interpreter(script:"4 ^quote a b c d e f g h").run
      quoted.inspect.should == "[«a b c d», :e, :f, :g, :h :: :: «»]"
    end
    
    it "should work when the integer is < 1" do
      quoted = interpreter(script:"-4 ^quote a b c d e f g h").run
      quoted.inspect.should == "[«», :a, :b, :c, :d, :e, :f, :g, :h :: :: «»]"
      
      quoted = interpreter(script:"0 ^quote a b c d e f g h").run
      quoted.inspect.should == "[«», :a, :b, :c, :d, :e, :f, :g, :h :: :: «»]"
    end
    
    it "should work when the integer is bigger than the script length" do
      quoted = interpreter(script:"124 ^quote a b c d e f g h").run
      quoted.inspect.should == "[«a b c d e f g h» :: :: «»]"
    end
  end
end
