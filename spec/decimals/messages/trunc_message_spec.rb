require_relative '../../spec_helper'

describe "Decimal" do
  describe "the :trunc message" do
    it "should be something Decimals recognize" do
      Decimal.recognized_messages.should include(:trunc)
    end

    it "should return BOTH the Int and Decimal portions of the number" do
      d = interpreter(script:"12.34 trunc").run
      d.contents.length.should == 2
      d.contents[0].value.should == 12
      d.contents[-1].value.should be_within(0.00001).of(0.34)
    end

    it "should be resilient to multiple application" do
      d = interpreter(script:"12.34 trunc trunc").run
      d.contents.length.should == 3
      d.contents[0].value.should == 12
      d.contents[1].value.should == 0
      d.contents[-1].value.should be_within(0.00001).of(0.34)
    end
  end
end
