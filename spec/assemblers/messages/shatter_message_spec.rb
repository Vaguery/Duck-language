#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":shatter" do
    it "should respond to :shatter like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"shatter",contents:[assembler(contents:numbers)])
      d.run
      d.contents.inspect.should == "[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]"
    end
    
    it "should release the buffered items as well" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"shatter",contents:[assembler(contents:numbers, buffer:[bool(F), decimal(12.34)])])
      d.run
      d.contents.inspect.should == "[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, F, 12.34]"
    end
  end
end