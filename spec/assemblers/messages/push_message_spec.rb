#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":push" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should place items that are :pushed onto its internal #buffer" do
      a = assembler(contents:[int(111)], buffer:[int(9999)])
      a.halt # to keep it from processing items
      d = interpreter(script:"F push", contents:[a]).run
      d.inspect.should == "[[111 :: 9999, F] :: :: «»]"
    end
    
    it "should process the items if the Assember isn't halted" do
      a = assembler(contents:[int(111)], buffer:[int(9999)])
      d = interpreter(script:"- push", contents:[a]).run
      d.inspect.should == "[[-9888 ::] :: :: «»]"
    end
  end
end
