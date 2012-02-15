#encoding: utf-8
require_relative '../../spec_helper'

describe "List" do
  describe "shatter message" do
    before(:each) do
      @d = interpreter(script:"shatter")
    end

    it "should be recognized by List items" do
      List.recognized_messages.should include(:shatter)
    end

    it "should queue the item's contents" do
      @d.script = script("( 1 F ) shatter")
      @d.run
      @d.contents.inspect.should == "[1, F]"
    end

    it "should work for an empty List" do
      s = List.new
      @d.contents.push s 
      @d.run
      @d.contents.length.should == 0
    end
    
    it "should leave interior Lists intact" do
      s2 = list([list([int(1),bool(F)]),int(2)])
      @d.contents.push s2
      @d.run
      @d.contents.inspect.should == "[(1, F), 2]"
    end
    
    it "should work on script-produced Lists" do
      @d.script = script("( 1 2 3 4 5 ( 6 7 8 ) ) 9 shatter")
      @d.run
      @d.contents.inspect.should == "[9, 1, 2, 3, 4, 5, (6, 7, 8)]"
    end
    
    it "should not fail when the List is empty" do
      @d.script = script("1121 ( ) shatter")
      lambda {@d.run}.should_not raise_error
    end
    
    it "should work with bound variables" do
      blowup = interpreter(script:"x x x shatter", binder:{x:list([int(3),int(4)])})
      blowup.run
      blowup.inspect.should == "[(3, 4), (3, 4), :x=(3, 4), 3, 4 :: :: «»]"
    end
  end
end
