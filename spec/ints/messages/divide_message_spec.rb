#encoding: utf-8
require_relative '../../spec_helper'

describe "Int" do
  describe "division" do
    describe "bare '÷' message" do
      before(:each) do
        @ducky = interpreter(script:"÷")
        @ducky.run
      end

      it "should produce a Message" do
        @ducky.contents[-1].should be_a_kind_of(Message)
      end

      it "should be waiting for one argument that responds to '÷'" do
        @ducky.contents[-1].needs.should == ['÷']
      end
    end

    describe "partial '÷' message" do
      before(:each) do
        @ducky = interpreter(script:"3 ÷")
        @ducky.run
      end

      it "should produce a Closure" do
        @ducky.contents[-1].should be_a_kind_of(Closure)
      end

      it "should be waiting for one Number argument" do
        @ducky.contents[-1].needs.should == ['neg']
      end
    end

    describe "finishing up division" do
      it "should delete the arguments and the closure" do
        ducky = interpreter(script:"12 -3 ÷").run
        ducky.contents.length.should == 1
      end

      it "should produce the correct result for 'straight' division" do
        interpreter(script:"27 3 ÷").run.contents[-1].value.should == 9
      end

      it "should produce the expected result for 'infix' division" do
        interpreter(script:"-11 ÷ -22").run.contents[-1].value.should == 2
      end

      it "should even work if the closure forms first" do
        interpreter(script:"÷ -12 60").run.contents[-1].value.should == -5
      end

      it "should not raise an error for division by 0" do
        lambda { interpreter(script:"÷ 0 60").run }.should_not raise_error
      end

      it "should produce an Error object when you try to divide by 0 (and consume the numerator)" do
        d = interpreter(script:"÷ 0 60")
        d.run.contents.inspect.should == "[err:[DIV0]]"
      end
    end

    describe "type casting" do
      it "should return an Int if both arguments are Ints" do
        interpreter(script:"60 12 ÷").run.contents[-1].should be_a_kind_of(Int)
      end

      it "should return a Decimal if either argument is a Decimal" do
        interpreter(script:"60.0 12 ÷").run.contents[-1].should be_a_kind_of(Decimal)
      end
    end


    describe "delayed division" do
      it "should work over complex sequences" do
        ducky = interpreter(script:"56 28 ÷ 7 2 ÷")
        ducky.run
        ducky.contents[-1].value.should == 3
      end

      it "should produce a result when all args and methods are accounted for" do
        "66 -22 ÷ 3 ÷".split.permutation do |p|
          [Int,Error].should include interpreter(script:p.join(" ")).run.contents[-1].class
        end
      end

      it "should produce some closures when there aren't enough args" do
        "21 ÷ -3 ÷ ÷".split.permutation do |p|
          [Int,Closure,Message].should include interpreter(script:p.join(" ")).run.contents[-1].class
        end
      end

    end
  end
end
