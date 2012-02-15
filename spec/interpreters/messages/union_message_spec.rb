#encoding:utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":∩" do
    it "should respond to :∪" do
      Interpreter.recognized_messages.should include(:∪)
    end
    
    it "should return an Assembler, because the script and binder are just too weird to think about" do
      i1 = interpreter(contents:[int(9)])
      i2 = interpreter(contents:[int(9), int(2)])
      wrapper = interpreter(script:"∪", contents:[i1,i2])
      wrapper.run
      wrapper.contents[0].should be_a_kind_of(Assembler)
      wrapper.contents[0].should_not be_a_kind_of(Interpreter)
    end
  end
end