#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":flatten" do
    before(:each) do
      @d = DuckInterpreter.new("flatten")
      subtree_1 = [Bool.new(false), Int.new(2), Int.new(4)]
      subtree_2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
      tree = subtree_1 + [
        Assembler.new(
          subtree_2 + [List.new(subtree_1)]
          )]
      @tree_full = Assembler.new(tree)
      # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) ::] ::]
    end
    
    it "should respond to :flatten like a List does" do
      @d.stack.push(@tree_full)
      @d.run
      @d.stack.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4) ::]]"
      @d.stack[0].should be_a_kind_of(Assembler)
    end
    
    it "should release buffered items intact if a sub-Assembler is flattened away" do
      @tree_full.contents[3].buffer = [Decimal.new(12.34)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] ::]
      @d.stack.push(@tree_full)
      @d.run
      @d.stack.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), 12.34 ::]]"
      @d.stack[0].should be_a_kind_of(Assembler)
      
    end
    
    it "should not flatten the buffer of any intact Assembler(s)" do
      @tree_full.contents[3].buffer = [Decimal.new(12.34)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] ::]
      @tree_full.buffer = [Decimal.new(56.78)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] :: 56.78]
      @d.stack.push(@tree_full)
      @d.run
      @d.stack.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), 12.34 :: 56.78]]"
      @d.stack[0].should be_a_kind_of(Assembler)
    end
  end
end