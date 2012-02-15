#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":ungreedy" do
    it "should turn the Assembler's greedy_flag to false" do
      a = Assembler.new
      a.ungreedy
      a.greedy_flag.should == false
    end
    
    it "should skip checking the staged item as an argument when set to false" do
      ungreedy = assembler(contents:[message("*")],buffer:[int(9)])
      ungreedy.ungreedy
      ungreedy.run
      ungreedy.inspect.should == "[:*, 9 ::]" 

      ungreedy.greedy
      ungreedy.buffer = [int(2)]
      ungreedy.run
      ungreedy.contents.inspect.should == "[18]"
    end
  end
end
