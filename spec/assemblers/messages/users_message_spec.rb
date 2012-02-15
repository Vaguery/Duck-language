#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":users" do
    it "should respond to :users like a List does, but return Lists" do
      items = [message("+"), message("inc"), message("empty")]
      d = interpreter(script:"3.1 users",contents:[assembler(contents:items)])
      d.run
      d.inspect.should == "[(:+), (:inc, :empty) :: :: «»]"
      d.contents[0].should be_a_kind_of(List)
      d.contents[1].should be_a_kind_of(List)
    end
    
    it "should check the buffer as well" do
      with_buffer = assembler(contents:[message("foo")],buffer:[message("inc")])
      d = interpreter(script:"3 users",contents:[with_buffer])
      d.run
      d.inspect.should == "[(:inc), (:foo) :: :: «»]" 
    end
  end
end