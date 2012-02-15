require_relative '../../spec_helper'

describe "Int" do
  describe "addition" do
    describe "bare '+' message" do
      before(:each) do
        @ducky = interpreter(script:"+")
        @ducky.run
      end

      it "should produce a Message" do
        @ducky.contents[-1].should be_a_kind_of(Message)
      end

      it "should be waiting for one argument that responds to '+'" do
        @ducky.contents[-1].needs.should == ['+']
      end
    end


    describe "partial '+' application" do
      before(:each) do
        @ducky = interpreter(script:"1 +")
        @ducky.run
      end

      it "should produce a Closure" do
        @ducky.contents[-1].should be_a_kind_of(Closure)
        @ducky.contents[-1].should_not be_a_kind_of(Message)
      end

      it "should be waiting for one Number argument" do
        @ducky.contents[-1].needs.should == ['neg']
      end
    end


    describe "finishing up addition" do
      it "should delete the arguments and the closure" do
        ducky = interpreter(script:"1 2 +").run
        ducky.contents.length.should == 1
      end

      it "should produce the correct result for 'straight' addition" do
        interpreter(script:"1 2 +").run.contents[-1].value.should == 3
      end

      it "should produce the expected result for 'infix' addition" do
        interpreter(script:"-11 + -22").run.contents[-1].value.should == -33
      end

      it "should even work if the closure forms first" do
        interpreter(script:"+ 17 22").run.contents[-1].value.should == 39
      end
    end


    describe "type casting" do
      it "should return an Int if both arguments are Ints" do
        interpreter(script:"-11 -22 +").run.contents[-1].should be_a_kind_of(Int)
      end

      it "should return a Decimal if either argument is a Decimal" do
        interpreter(script:"0.2 -22 +").run.contents[-1].should be_a_kind_of(Decimal)
      end
    end


    describe "delayed addition" do
      it "should work over complex sequences" do
        ducky = interpreter(script:"1 2 + 3 4 + +")
        ducky.run
        ducky.contents.inspect.should == "[10]"
      end


      it "should produce a number when all args and methods are accounted for" do
        "1 2 + 3 +".split.permutation do |p|
          ducky = interpreter(script:p.join(" "))
          ducky.run.contents[-1].should be_a_kind_of(Int)
        end
      end

      it "should produce some closures when there aren't enough args" do
        "1 + -3 + +".split.permutation do |p|
          [Int,Message,Closure].should include interpreter(script:p.join(" ")).run.contents[-1].class
        end
      end

      it "should leave unasked-for argumnts intact" do
        d = interpreter(script:"1 2 3 4 5 +").run
        d.contents.inspect.should == "[1, 2, 3, 9]"
      end
    end
  end
end
