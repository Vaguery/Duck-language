#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":copy" do
    it "should respond to :copy like a List does" do
      
      numbers = (0..10).collect {|i| int(i*i)}
      
      d = interpreter( script:"copy", contents:[assembler( :contents => numbers )] )
      d.run
      d.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 100 ::] :: :: «»]"
      # d.contents[0].should be_a_kind_of(Assembler)
    end
  end
end