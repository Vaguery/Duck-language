#encoding:utf-8
require_relative '../spec_helper'

describe "the Iterator class" do
  describe "initialization" do
    it "can be initialized with defaults" do
      ns = Iterator.new
      ns.start.should == 0
      ns.end.should == 0
      ns.inc.should == 1
      ns.index.should == 0
      ns.contents.should == []
    end
    
    it "should set the index to the start_value if not specified" do
      Iterator.new(start:11, end:8).index.should == 11
    end
    
    it "should take accept any or all the args to overwrite the defaults" do
      Iterator.new(start:9).start.should == 9
      Iterator.new(end:1.1).end.should == 1.1
      Iterator.new(start:-9.2, end:11.3, inc:1.1).inc.should == 1.1
      Iterator.new(contents:[int(8)]).contents[0].should be_a_kind_of(Int)
    end
  end
  
  describe "visualization" do
    it "should evoke the Span representation, showing its bound_item" do
      Iterator.new(start:-121, end:33).inspect.should == "(-121..-121..33)=>[]"
      Iterator.new(start:-121, end:33, contents:[int(8)]).inspect.
        should == "(-121..-121..33)=>[8]"
    end
  end
end