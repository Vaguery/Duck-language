#encoding:utf-8
require_relative '../../spec_helper'

describe "Proxy" do
  before(:each) do
    @easy_version = "^clear".intern
  end
  
  describe ":^clear" do
    it "should be recognized by a Proxy item" do
      Proxy.recognized_messages.should include(@easy_version)
    end
    
    it "should immediately flush the buffer into a List in the contents" do
      interpreter(script:"2 4 *", buffer:[message("^clear".intern), int(1), int(2)]).run.inspect.should == 
        "[(1, 2), 8 :: :: «»]"
    end
  end
end
