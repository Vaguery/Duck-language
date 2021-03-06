require_relative '../../spec_helper'

describe "Decimal" do
  describe "the :ceiling message" do
    it "should be something Decimals recognize" do
      Decimal.recognized_messages.should include(:ceiling)
    end

    it "should return a Decimal with a value equal to the floor of the original" do
      decimal(12.34).ceiling.value.should == 13.0
      decimal(-12.34).ceiling.value.should == -12.0
    end
  end
end
