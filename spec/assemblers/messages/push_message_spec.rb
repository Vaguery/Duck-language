#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":push" do
    before(:each) do
      @s = Assembler.new
    end

    it "should place items that are :pushed onto its internal #buffer" do
      @s.stub!(:process_buffer) # to stop the buffer being cleared
      @s.push(Int.new(1))
      @s.buffer.length.should == 1
    end

    it "should be able to append multiple items to the buffer by pushing an Array" do
      @s.stub!(:process_buffer) # to stop the buffer being cleared
      @s.push [Int.new(3),Int.new(4)]
      @s.buffer.length.should == 2
      @s.buffer[0].value.should == 3
      @s.buffer[1].value.should == 4
    end

    it "should take items from its contents to fill the lowest staged item's #needs" do
      @s.push([Int.new(7), Decimal.new(3.5), Message.new("+")])
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[10.5]"
    end

    it "should work for methods that return multiple values" do
      @s.contents.push(Decimal.new(1.125))
      @s.push(Message.new("trunc"))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[1, 0.125]"
    end

    it "should work for methods that return nothing" do
      @s.contents.push(Message.new("+"))
      @s.contents.push(Message.new("-"))
      @s.push(Message.new("zap"))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[:+]"
    end

    it "should check to see if the buffered items are wanted by anything in the contents" do
      @s.contents.push(Message.new("*"))
      @s.contents.push(Int.new(-2))
      @s.push(Int.new(3))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[-6]"
    end

    it "should work when the results are nil" do
      @s.contents.push(Message.new("zap"))
      @s.push([Message.new("+"), Message.new("-")])
      @s.contents.inspect.should == "[:-]"
    end

    it "should work when the results are an array" do
      @s.contents.push(Message.new("trunc"))
      @s.push(Decimal.new(125.125))
      @s.contents.inspect.should == "[125, 0.125]"
    end

    it "should return the updated Assembler" do
      @s.push(Int.new(11)).should == @s
      @s.contents.inspect.should == "[11]"
    end

    it "should be able to handle items already present on the buffer"
  end

  describe "'being on its own stack'" do
    it "should present itself as the 'bottom' item on its own stack, when processing is underway" do
      pending
      tenuous = Assembler.new
      tenuous.contents.push(Int.new(3))
      tenuous.contents.push(Int.new(4))
      result = tenuous.push(Message.new("shatter"))
      result.should be_a_kind_of(Array)
      result.inspect.should == "[3, 4]"
    end
  end
end
