#encoding:utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":[]" do
    it "should respond to :[] like a List does" do
      numbers = (0..10).collect {|i| int(i*i)}
      d = interpreter(script:"3 []", contents:[interpreter(buffer:numbers)])
      d.run
      d.inspect.should == "[9 :: :: «»]"
    end
    
    it "should include items in the Buffer" do
      d = interpreter(script:"7 []")
      numbers = (0..5).collect {|i| int(i*i)}
      with_buffer = interpreter(contents:numbers, buffer:numbers)
      d.contents.push(with_buffer)
      d.inspect.should == "[[0, 1, 4, 9, 16, 25 :: 0, 1, 4, 9, 16, 25 :: «»] :: :: «7 []»]"
      d.run
      d.inspect.should == "[1 :: :: «»]"
    end
  end
end