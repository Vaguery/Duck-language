#encoding:utf-8
require_relative '../spec_helper'

describe "the Assembler item" do
  it "should be a subclass of List" do
    Assembler.new.should be_a_kind_of(List)
  end
  
  describe "visualization" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should look like an Array" do
      @s.push(Int.new(7))
      @s.push(Int.new(3))
      @s.inspect.should == "[7, 3]"
    end
  end
end