#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":flatten" do
    before(:each) do
      @d = interpreter(script:"flatten")
      subtree_1 = [bool(F), int(2), int(4)]
      subtree_2 = [bool(T), int(2), decimal(4.0)]
      tree = subtree_1 + [
        assembler(
          contents:subtree_2 + [list(subtree_1)]
          )]
      @tree_full = assembler(contents:tree)
      # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) ::] ::]
    end
    
    it "should respond to :flatten like a List does" do
      @d.contents.push(@tree_full)
      @d.run
      @d.contents.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4) ::]]"
      @d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should release buffered items intact if a sub-Assembler is flattened away" do
      @tree_full.contents[3].buffer = [decimal(12.34)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] ::]
      @d.contents.push(@tree_full)
      @d.run
      @d.contents.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), 12.34 ::]]"
      @d.contents[0].should be_a_kind_of(Assembler)
      
    end
    
    it "should not flatten the buffer of any intact Assembler(s)" do
      @tree_full.contents[3].buffer = [decimal(12.34)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] ::]
      @tree_full.buffer = [decimal(56.78)] # [F, 2, 4, [T, 2, 4.0, (F, 2, 4) :: 12.34] :: 56.78]
      @d.contents.push(@tree_full)
      @d.run
      @d.contents.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), 12.34 :: 56.78]]"
      @d.contents[0].should be_a_kind_of(Assembler)
    end
    
    it "should release the script and binder of an Interpreter it flattens away, but remove the PROXY" do
      an_interpreter = interpreter(script:"foo bar", 
        contents:[int(9)], buffer:[decimal(12.34)], binder:{x:bool(F)})
      contains_an_interpreter = Assembler.new contents:[an_interpreter]
      contains_an_interpreter.flatten.inspect.should == "[{:x=F}, 9, 12.34, «foo bar» ::]"
    end
  end
end