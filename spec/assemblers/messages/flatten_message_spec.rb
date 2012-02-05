#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":flatten" do
    before(:each) do
      subtree_1 = [Bool.new(false), Int.new(2), Int.new(4)]
      subtree_2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      tree = subtree_1 + [Assembler.new(subtree_2+[List.new(subtree_1)])] + [List.new(subtree_1)]
      @tree_full = Assembler.new(tree)
    end
    
    it "should respond to :flatten like a List does" do
      pending
      d = DuckInterpreter.new("flatten")
      subtree_1 = [Bool.new(false), Int.new(2), Int.new(4)]
      subtree_2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      tree = subtree_1 + [Assembler.new(subtree_2+[List.new(subtree_1)])] + [List.new(subtree_1)]
      d.stack.push(@tree_full)
      d.run
      d.stack.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), F, 2, 4 ::]]"
      d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should include the buffer items in the result" do
      pending
      @tree_full.buffer.push(Decimal.new(12.34))
      @tree_full.flatten.inspect.should == "[F, 2, 4, T, 2, 4.0, (F, 2, 4), F, 2, 4 :: 12.34]"
    end
    
    it "should NOT flatten the buffered items"
  end
end