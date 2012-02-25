#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "the :index= message for Iterators" do
    it "should be something an Iterator recognizes" do
      Iterator.recognized_messages.should include(:index=)
    end
    
    it "should return a Closure looking for a Number" do
      setter = Iterator.new.send(:index=)
      setter.should be_a_kind_of(Closure)
      setter.needs.should == ["neg"]
    end
    
    it "should set the index to the value of the arg it grabs" do
      reset = interpreter(script:"index= 3", contents:[Iterator.new]).run
      reset.contents[0].index.should == 3
    end
    
    it "should be willing to set the index of an integer Iterator to any Number value" do
      reset = interpreter(script:"index= 3.8", contents:[Iterator.new]).run
      reset.contents[0].index.should == 3.8
    end
  end
end
