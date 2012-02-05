#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do

  describe ":count" do
    it "should respond to :count like a List does" do
      Assembler.new.count.should be_a_kind_of(Int)
      Assembler.new(*[Int.new(1)]*12).count.value.should == 12
    end
  
    it "should include items on its buffer"
  end

end