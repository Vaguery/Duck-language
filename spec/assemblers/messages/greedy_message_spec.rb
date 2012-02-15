#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":greedy" do
    it "should turn the Assembler's greedy_flag to true" do
      a = Assembler.new
      a.greedy_flag = false
      a.greedy
      a.greedy_flag.should == true
    end
    
    it "should skip checking the staged item as an argument when set to false" do
      ungreedy = assembler(contents:[message("*")],buffer:[int(9)])
      ungreedy.greedy_flag = false
      ungreedy.run
      ungreedy.inspect.should == "[:*, 9 ::]" 

      ungreedy.greedy
      ungreedy.buffer = [int(2)]
      ungreedy.run
      ungreedy.contents.inspect.should == "[18]"
    end
  end
end
