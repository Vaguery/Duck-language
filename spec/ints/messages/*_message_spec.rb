require_relative '../../spec_helper'

describe "Int" do
  describe "multiplication" do
    describe "bare '*' message" do
      before(:each) do
        @ducky = interpreter(script:"*")
        @ducky.run
      end

      it "should produce a Message" do
        @ducky.contents[-1].should be_a_kind_of(Message)
      end

      it "should be waiting for one argument that responds to '*'" do
        @ducky.contents[-1].needs.should == ['*']
      end
    end

    describe "partial '*' message" do
      before(:each) do
        @ducky = interpreter(script:"3 *").run
      end

      it "should produce a Closure" do
        @ducky.contents[-1].should be_a_kind_of(Closure)
      end

      it "should be waiting for one Number argument" do
        @ducky.contents[-1].needs.should == ['neg']
      end
    end

    describe "finishing up multiplication" do
      it "should delete the arguments and the closure" do
        ducky = interpreter(script:"2 -3 *").run
        ducky.contents.length.should == 1
      end

      it "should produce the correct result for 'straight' multiplication" do
        interpreter(script:"2 3 *").run.contents[-1].value.should == 6
      end

      it "should produce the expected result for 'infix' multiplication" do
        interpreter(script:"-11 * -22").run.contents[-1].value.should == 242
      end

      it "should even work if the closure forms first" do
        interpreter(script:"* 17 22").run.contents[-1].value.should == 374
      end
    end

    describe "type casting" do
      it "should return an Int if both arguments are Ints" do
        interpreter(script:"17 22 *").run.contents[-1].should be_a_kind_of(Int)
      end

      it "should return a Decimal if either argument is a Decimal" do
        interpreter(script:"1.5 22 *").run.contents[-1].should be_a_kind_of(Decimal)
      end
    end


    describe "delayed multiplication" do
      it "should work over complex sequences" do
        ducky = interpreter(script:"1 2 * 3 4 * *")
        ducky.run
        ducky.contents[-1].value.should == 24
      end


      it "should produce a number when all args and methods are accounted for" do
        "11 -22 * 33 *".split.permutation do |p|
          interpreter(script:p.join(" ")).run.contents[-1].should be_a_kind_of(Int)
        end
      end

      it "should produce some closures when there aren't enough args" do
        "21 * -3 * *".split.permutation do |p|
          [Int,Closure,Message].should include interpreter(script:p.join(" ")).run.contents[-1].class
        end
      end

    end
  end
end
