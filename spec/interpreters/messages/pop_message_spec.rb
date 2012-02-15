#encoding: utf-8
require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :pop message" do
    it "should be something the Interpreter recognizes" do
      Interpreter.recognized_messages.should include(:pop)
    end

    it "should make the top stack item disappear" do
      d = interpreter(contents:[int(1)]*3)
      
      wrapper = interpreter(script:"pop", contents:[d])
      wrapper.run
      wrapper.inspect.should == "[[1, 1 :: :: «»], 1 :: :: «»]"
    end
    
  end
end
