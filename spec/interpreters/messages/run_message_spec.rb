#encoding:utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":run" do
    it "should be a recognized message" do
      Interpreter.recognized_messages.should include(:run)
    end
    
    it "should process all the items from its script and buffer" do
      wb = interpreter(script:"+ * *",contents:[int(1), int(2)], buffer:[int(3), int(4)])
      wb.run.inspect.should == "[14 :: :: «»]"
    end
    
    it "should stage all buffered items fully and generate intermediate results" do
      wb = interpreter(contents:[message("*"), message("+"),int(1)],
        buffer:[int(3), int(4)])
      wb.run.inspect.should == "[16 :: :: «»]"
    end
    
    it "should change the @halted state of the Interpreter to false" do
      wb = Interpreter.new
      wb.halt
      wb.halted.should == true
      
      wb.run
      wb.halted.should == false
    end
  end
end