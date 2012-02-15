require_relative '../spec_helper'

describe "Decimal stack item" do
  
  describe "initialization" do
    it "should be a kind of Number" do
      Decimal.new(1.234).should be_a_kind_of(Number)
    end
    
    it "should have an obvious value" do
      decimal(1.234).value.should == 1.234
    end
    
    it "should have a Duck shortcut" do
      decimal(1.2).value.should == 1.2
    end
  end
  
  
  describe "parsing" do
    it "make a Float from any decimal-containing number" do
      d = interpreter(script:"1.234").run
      d.contents[0].should be_a_kind_of(Decimal)
      d.contents[0].value.should == 1.234
    end
    
    it "should work with negatives" do
      d = interpreter(script:"-1231.234").run
      d.contents[0].should be_a_kind_of(Decimal)
      d.contents[0].value.should == -1231.234
    end
    
    it "should not recognize messed up floats" do
      d = interpreter(script:"-1231.23.4").run
      d.contents[0].should_not be_a_kind_of(Decimal)
      d.contents[0].should be_a_kind_of(Message)
    end
    
    it "should work for decimal-terminated numbers with no fractions" do
      d = interpreter(script:"-1231.").run
      d.contents[0].should be_a_kind_of(Decimal)
    end
  end
  
  
  
  
  describe "visualization" do
    it "should have a string representation equal to its value" do
      decimal(1.234).to_s.should == "1.234"
    end
  end
end