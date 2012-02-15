require_relative '../../spec_helper'

describe "Interpreter" do
  describe "Stack response to :reverse" do
    it "should be a message the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:reverse)
    end
    
    it "should invert the stack if it passes through the stack items" do
      d = interpreter(script:"1 2 3 4 5").run
      d.reverse
      d.contents.inspect.should == "[5, 4, 3, 2, 1]"
    end
  end
end
