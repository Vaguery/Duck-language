#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter" do
  describe "deep_copy" do
    before(:each) do
      @i = interpreter(script:"foo bar", contents:[int(99)], buffer:[bool(F)])
      @i.halt
    end
    
    it "should deep_copy the script" do
      @i.deep_copy.script.inspect.should == "«foo bar»"
      @i.deep_copy.script.object_id.should_not == @i.script.object_id
    end
    
    it "should deep_copy the contents" do
      @i.deep_copy.contents.inspect.should == "[99]"
      @i.deep_copy.contents[0].object_id.should_not == @i.contents[0].object_id
    end
    
    it "should deep_copy the buffer" do
      @i.deep_copy.buffer.inspect.should == "[F]"
      @i.deep_copy.buffer[0].object_id.should_not == @i.buffer[0].object_id
    end
    
    it "should preserve the @halted state" do
      @i.deep_copy.halted.should == true
    end
    
    
    describe "deep_copy" do
      it "should transfer #ticks" do
        a = interpreter(buffer:[int(3)]*122)
        a.run
        a.ticks.should == 122
        a.deep_copy.ticks.should == 122
      end

      it "should transfer max_ticks" do
        a = assembler
        a.max_ticks = 9000
        a.deep_copy.max_ticks.should == 9000
      end
    end
  end
end