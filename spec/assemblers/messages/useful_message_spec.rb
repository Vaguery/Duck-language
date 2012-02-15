#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":useful" do
    it "should respond to :useful like a List does, but return Lists" do
      items = [bool(F), int(2), int(4)]
      d = interpreter(script:"* useful",contents:[assembler(contents:items)])
      d.run
      d.inspect.should == "[(2, 4), (F) :: :: «»]"
      d.contents[0].should be_a_kind_of(List)
      d.contents[1].should be_a_kind_of(List)
    end
    
    it "should check the buffer as well" do
      with_buffer = assembler(contents:[message("foo")],buffer:[int(77)])
      d = interpreter(script:"- useful",contents:[with_buffer])
      d.run
      d.inspect.should == "[(77), (:foo) :: :: «»]"
    end
  end
end