#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":give" do
    it "should produce a List" do
      list_of_messages = ["neg", "trunc", "to_int"].collect {|i| message(i)}
      as = assembler(contents:list_of_messages)
      d = interpreter(script:"12.25 give", contents:[as])
      d.run
      d.inspect.should == "[(-12.25, 12, 0.25, 12) :: :: «»]"
    end
    
    
    it "should merge the buffer with the contents before acting" do
      d = interpreter(script:"12.25 give")
      as = assembler(contents:["neg", "trunc", "to_int"].collect {|i| message(i)}, buffer:[message("to_bool")])
      d.contents.push(as)
      d.run
      d.contents.inspect.should == "[(-12.25, 12, 0.25, 12, T)]"
    end
  end
end