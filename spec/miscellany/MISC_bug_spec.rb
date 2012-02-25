#encoding: utf-8
require_relative '../spec_helper'
require 'timeout'

describe "various bad behaviors that cropped up during stress-testing" do
  it "should be able to run Bad Boy 1" do
    # this appears to be a bug involving :step passed to an Assembler with no buffered items?
    bad_boy = interpreter(script:"step to_assembler to_binder foo known[] ")
    lambda { bad_boy.run }.should_not raise_error
  end
  
  
  it "should be able to run Bad Boy 2" do
    # this appears to be a bug involving Interpreter#flatten
    bad_boy = interpreter(script:"to_interpreter flatten bundle bundle snap greedy? 7 shatter 5.6 9.5 x",
    binder:{x:int(3)})
    lambda { bad_boy.run }.should_not raise_error
  end
  
  it "should be able to manage :fold_down sent to Bad Boy 31" do
    bad_boy31 = interpreter(buffer:[message(:fold_down)],
      contents:[list([message(:fold_down),Binder.new([Iterator.new]), message(:fold_down)])]).run
    bad_boy31.inspect.should == "[{(0..0..0)=>[]} :: :: «»]"
  end
  
end

