#encoding:utf-8
require_relative '../../spec_helper'

describe "Decimal" do
  describe "÷" do
    describe "partial '÷' message" do
      before(:each) do
        @ducky = DuckInterpreter.new("3.2 ÷")
        @ducky.run
      end

      it "should produce a Closure" do
        @ducky.stack[-1].should_not be_a_kind_of(Message)
      end

      it "should be waiting for one Number argument" do
        @ducky.stack[-1].needs.should == ['neg']
      end
    end

    describe "finishing up division" do
      it "should delete the arguments and the closure" do
        ducky = DuckInterpreter.new("12.0 -3.0 ÷").run
        ducky.stack.length.should == 1
      end

      it "should produce the correct result for 'straight' division" do
        DuckInterpreter.new("27.3 3.0 ÷").run.stack[-1].value.should be_within(0.001).of(9.1)
      end

      it "should produce the expected result for 'infix' division" do
        DuckInterpreter.new("-11.0 ÷ -33.0").run.stack[-1].value.should be_within(0.0001).of(3.0)
      end

      it "should even work if the closure forms first" do
        DuckInterpreter.new("÷ -12.0 72.0").run.stack[-1].value.should be_within(0.001).of(-6.0)
      end

      it "should not fail for division by 0" do
        lambda { DuckInterpreter.new("÷ 0.0 60.0").run }.should_not raise_error
      end

      it "should produce an Error object when you try to divide by 0" do
        d = DuckInterpreter.new("÷ 0.0 60.0")
        d.run.stack.inspect.should == "[err:DIV0]"
      end
    end


    describe "delayed division" do
      it "should work over complex sequences" do
        ducky = DuckInterpreter.new("56.0 28.0 ÷ 7.0 2.0 ÷")
        ducky.run
        ducky.stack[-1].value.should be_within(0.001).of(3.5)
      end

      it "should produce a number when all args and methods are accounted for" do
        "66.0 -22.0 ÷ 1.0 ÷".split.permutation do |p|
          DuckInterpreter.new(p.join(" ")).run.stack[-1].should be_a_kind_of(Decimal)
        end
      end

      it "should produce some closures when there aren't enough args" do
        "21.0 ÷ -3.0 ÷ ÷".split.permutation do |p|
          [Closure,Message].should include DuckInterpreter.new(p.join(" ")).run.stack[-1].class
        end
      end
    end
  end
end
