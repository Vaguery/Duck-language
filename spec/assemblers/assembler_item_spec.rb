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
    
    it "should be displayed in square brackets, with a double colon separating the buffer" do
      @s.push(Int.new(7))
      @s.push(Int.new(3))
      @s.inspect.should == "[7, 3 ::]"
      
      @s.buffer.push(Int.new(11))
      @s.buffer.push(Message.new("foo"))
      @s.inspect.should == "[7, 3 :: 11, :foo]"
      
      Assembler.new.inspect.should == "[::]"
    end
  end
end