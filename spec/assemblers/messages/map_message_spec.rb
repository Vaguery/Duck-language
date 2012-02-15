#encoding:utf-8
require_relative '../../spec_helper'

describe "Assembler" do
  describe ":map" do
    it "should produce a List" do
      d = interpreter(script:"neg map")
      as = assembler(contents:(0..3).collect {|i| int(i*i*i)})
      d.contents.push(as)
      d.run
      d.contents.inspect.should == "[(0, -1, -8, -27)]"
    end
    
    it "should merge the buffer with the contents before acting" do
      d = interpreter(script:"neg map")
      as = assembler(contents:(0..3).collect {|i| int(i*i*i)},
        buffer:(12..13).collect {|i| int(i*i*i)})
      d.contents.push(as)
      d.run
      d.contents.inspect.should == "[(0, -1, -8, -27, -1728, -2197)]"
    end
  end
end