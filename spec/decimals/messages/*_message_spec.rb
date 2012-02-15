require_relative '../../spec_helper'

describe "Decimal" do
  describe "multiplication" do
    describe "partial '*' application" do
      before(:each) do
        @ducky = interpreter(script:"1.23 *").run
      end
      
      it "should produce a Closure" do
        @ducky.contents[-1].should be_a_kind_of(Closure)
        @ducky.contents[-1].should_not be_a_kind_of(Message)
      end
      
      it "should be waiting for one Number argument" do
        @ducky.contents[-1].needs.should == ['neg']
      end
    end
    
    
    describe "finishing up multiplication" do
      it "should delete the arguments and the closure" do
        ducky = interpreter(script:"1.1 2.2 *").run
        ducky.contents.length.should == 1
      end
      
      it "should produce the correct result for 'straight' subtraction" do
        interpreter(script:"1.1 2.2 *").run.contents[-1].value.should be_within(0.0001).of(2.42)
      end
      
      it "should produce the expected result for 'infix' addition" do
        interpreter(script:"-11.11 * -22.22").run.contents[-1].value.should be_within(0.0001).of(246.8642)
      end
      
      it "should even work if the closure forms first" do
        interpreter(script:"* 17.17 22.22").run.contents[-1].value.should be_within(0.0001).of(381.5174)
      end
    end
    
    describe "delayed multiplication" do
      it "should work over complex sequences" do
        ducky = interpreter(script:"1.2 2.2 * 3.4 4.5 * *")
        ducky.run
        ducky.contents[0].value.should be_within(0.001).of(40.392)
      end
      
      
      it "should produce a number when all args and methods are accounted for" do
        "1.1 2.2 * 3.3 *".split.permutation do |p|
          ducky = interpreter(script:p.join(" "))
          ducky.run.contents[-1].should be_a_kind_of(Decimal)
        end
      end
      
      it "should produce some closures when there aren't enough args" do
        "-1.5 * -3.2 * *".split.permutation do |p|
          [Decimal,Message,Closure].should include interpreter(script:p.join(" ")).run.contents[-1].class
        end
      end
      
      it "should leave unasked-for argumnts intact" do
        d = interpreter(script:"1.1 2.2 3.3 4.2 5.2 *").run
        d.contents[-1].value.should be_within(0.0001).of(21.84)
      end
    end
  end
end
