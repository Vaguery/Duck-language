require_relative '../../spec_helper'

describe "Int" do
  describe "subtraction" do
    describe "bare '-' message" do
      before(:each) do
        @ducky = interpreter(script:"-").run
      end

      it "should produce a Message" do
        @ducky.contents[-1].should be_a_kind_of(Message)
      end

      it "should be waiting for one argument that responds to '-'" do
        @ducky.contents[-1].needs.should == ['-']
      end
    end

    describe "partial '-' message" do
      before(:each) do
        @ducky = interpreter(script:"1 -").run
      end

      it "should produce a Closure" do
        @ducky.contents[-1].should be_a_kind_of(Closure)
      end

      it "should be waiting for one Number argument" do
        @ducky.contents[-1].needs.should == ['neg']
      end
    end

    describe "finishing up subtraction" do
      it "should delete the arguments and the closure" do
        ducky = interpreter(script:"1 2 -").run
        ducky.contents.length.should == 1
      end

      it "should produce the correct result for 'straight' subtraction" do
        interpreter(script:"13 27 -").run.contents[-1].value.should == -14
      end

      it "should produce the expected result for 'infix' subtraction" do
        interpreter(script:"13 - 27").run.contents[-1].value.should == 14
      end

      it "should even work if the closure forms first" do
        interpreter(script:"- 13 27").run.contents[-1].value.should == 14
      end
    end

    describe "type casting" do
      it "should return an Int if both arguments are Ints" do
        interpreter(script:"- 13 27").run.contents[-1].should be_a_kind_of(Int)
      end

      it "should return a Decimal if either argument is a Decimal" do
        interpreter(script:"1.3 27 -").run.contents[-1].should be_a_kind_of(Decimal)
      end
    end


    describe "delayed subtraction" do
      it "should work over complex sequences" do
        ducky = interpreter(script:"1 2 - 3 - 4 -")
        ducky.run
        ducky.contents[-1].value.should == -8 # ((1-2)-3)-4
      end

      it "should produce a numeric result for any permutation (when all args are accounted for)" do
        "1 - 3 4 -".split.permutation do |p|
          interpreter(script:p.join(" ")).run.contents[-1].should be_a_kind_of(Int)
        end
      end

    end
  end
end
