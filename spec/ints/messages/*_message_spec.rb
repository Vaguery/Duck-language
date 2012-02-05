require_relative '../../spec_helper'

describe "Int" do
  describe "multiplication" do
    describe "bare '*' message" do
      before(:each) do
        @ducky = DuckInterpreter.new("*")
        @ducky.step
      end

      it "should produce a Message" do
        @ducky.stack[-1].should be_a_kind_of(Message)
      end

      it "should be waiting for one argument that responds to '*'" do
        @ducky.stack[-1].needs.should == ['*']
      end
    end

    describe "partial '*' message" do
      before(:each) do
        @ducky = DuckInterpreter.new("3 *")
        @ducky.step.step
      end

      it "should produce a Closure" do
        @ducky.stack[-1].should be_a_kind_of(Closure)
      end

      it "should be waiting for one Number argument" do
        @ducky.stack[-1].needs.should == ['neg']
      end
    end

    describe "finishing up multiplication" do
      it "should delete the arguments and the closure" do
        ducky = DuckInterpreter.new("2 -3 *").run
        ducky.stack.length.should == 1
      end

      it "should produce the correct result for 'straight' multiplication" do
        DuckInterpreter.new("2 3 *").run.stack[-1].value.should == 6
      end

      it "should produce the expected result for 'infix' multiplication" do
        DuckInterpreter.new("-11 * -22").run.stack[-1].value.should == 242
      end

      it "should even work if the closure forms first" do
        DuckInterpreter.new("* 17 22").run.stack[-1].value.should == 374
      end
    end

    describe "type casting" do
      it "should return an Int if both arguments are Ints" do
        DuckInterpreter.new("17 22 *").run.stack[-1].should be_a_kind_of(Int)
      end

      it "should return a Decimal if either argument is a Decimal" do
        DuckInterpreter.new("1.5 22 *").run.stack[-1].should be_a_kind_of(Decimal)
      end
    end


    describe "delayed multiplication" do
      it "should work over complex sequences" do
        ducky = DuckInterpreter.new("1 2 * 3 4 * *")
        ducky.run
        ducky.stack[-1].value.should == 24
      end


      it "should produce a number when all args and methods are accounted for" do
        "11 -22 * 33 *".split.permutation do |p|
          DuckInterpreter.new(p.join(" ")).run.stack[-1].should be_a_kind_of(Int)
        end
      end

      it "should produce some closures when there aren't enough args" do
        "21 * -3 * *".split.permutation do |p|
          [Int,Closure,Message].should include DuckInterpreter.new(p.join(" ")).run.stack[-1].class
        end
      end

    end
  end
end
