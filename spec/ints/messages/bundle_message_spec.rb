#encoding:utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "the :bundle message" do
    it "should be recognized by Ints" do
      Int.recognized_messages.should include(:bundle)
    end

    it "should produce a Collector gathering N items responding to :be" do
      int(3).bundle.needs.should == ["be"]
    end

    it "should produce a List when it's done gathering items" do
      d = interpreter(script:"3 bundle a b c d").run
      d.contents.inspect.should == "[(:a, :b, :c), :d]"
    end

    it "should produce an empty List if the integer is negative or 0" do
      d = interpreter(script:"-3 bundle foo 0 bundle bar").run
      d.contents.inspect.should == "[(), :foo, (), :bar]"
    end
    
    it "should be ready to grab more items when they appear" do
      d = interpreter(script:"12 bundle 3 4").run
      d.contents.inspect.should == "[λ( (3, 4, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)]"
    end
  end
end
