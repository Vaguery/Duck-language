#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "the :map message for Lists" do
    it "should be something Lists recognize" do
      List.recognized_messages.should include(:map)
    end

    it "should produce a closure, looking for any item" do
      List.new.give.should be_a_kind_of(Closure)
      List.new.give.needs.should == ["be"]
    end
    
    it "should produce a new List that results from each List item grabbing the item" do
      d = interpreter(script:"( 2 3 4 ) - map").run
      d.contents.inspect.should == "[(λ(? - 2,[\"neg\"]), λ(? - 3,[\"neg\"]), λ(? - 4,[\"neg\"]))]"
    end
    
    
    it "should be possible to hand in multiple arguments sequentially and just have the salient ones connect" do
      d = interpreter(script:"( 1 2 3 4 ) * map 2 give").run
      d.contents.inspect.should == "[(2, 4, 6, 8)]"
    end
    
    it "should work for empty Lists" do
      d = interpreter(script:"( ) - map").run
      d.contents.inspect.should == "[()]"
    end
    
    it "should work when the result of a message is an Array of items" do
      d = interpreter(script:"( 0.62 ) map trunc").run
      d.contents.inspect.should == "[(0, 0.62)]"
    end
    
    it "should work when the result of a message is Nil" do
      d = interpreter(script:"( - ) zap map").run
      d.contents.inspect.should == "[()]"
    end
    
    it "should work with Collectors (and Pipes, by extension)" do
      d = interpreter(script:"( 1 2 3 4 )").run
      d.contents.push(Collector.new(2))
      d.script = script("map foo give") # map the Collector to all items, then quickly give it the final "foo"
      d.run
      d.contents.inspect.should == "[((1, :foo), (2, :foo), (3, :foo), (4, :foo))]"
    end
  end
end
