#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":[]=" do
    it "should respond to :[]= like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      
      d = interpreter(script:"4 F []=", contents:[assembler(contents:numbers)] )
      d.run
      d.inspect.should == "[[0, 1, 4, 9, F, 25, 36, 49, 64, 81, 100 ::] :: :: «»]"
    end
    
    describe "should handle a tricky edge case correctly" do
      
      it "should produce a Closure when a 2-arity Closure is an arg of Assembler#map" do
        tricky = interpreter(script:"[]= map", contents:[assembler(buffer:[int(3), int(5)]), list([bool(F)])])
        tricky.run
        tricky.contents[0].contents.each {|item| item.should be_a_kind_of(Closure)}
      end

    end
    
    it "should include the buffer as elements for replacement" do
      numbers = (0..3).collect {|i| int(i*i)}
      short_stack = assembler(contents:numbers, buffer:[int(999)])
      
      d = interpreter(script:"9 F []=", contents:[short_stack])
      
      d.inspect.should == "[[0, 1, 4, 9 :: 999] :: :: «9 F []=»]"
      
      d.run
      d.inspect.should == "[[0, 1, 4, 9 :: F] :: :: «»]" 
    end
  end
end