#encoding: utf-8
require_relative '../spec_helper'

describe "Interpreter" do
  describe "its Binder" do
    describe "initialization" do
      describe "when creating an Interpreter" do
        it "has an (empty) Binder attribute" do
          Interpreter.new.binder.should be_a_kind_of(Binder)
        end
      end
      
      describe "setting values" do
        it "should be possible to simply attach them by hand" do
          ducky = Interpreter.new
          ducky.binder.contents << variable("x", int(9))
          ducky.binder.contents << variable("y", bool(F))
          ducky.binder.inspect.should == "{:x=9, :y=F}"
        end
      end
      
      describe "running scripts" do
        describe "processing the buffer" do
          it "should treat variables that don't occur in the Interpreter's binder as pure Messages" do
            ducky = interpreter(script:"x x +", binder:{}) 
            ducky.run
            ducky.inspect.should == "[:x, :x, :+ :: :: «»]"
          end
          
          it "should be able to produce the associated binder value if it is present" do
            ducky = interpreter(script:"x + x", binder:{x:int(33)})
            ducky.run
            ducky.inspect.should == "[:x=33, 66 :: :: «»]"
          end
          
          it "should produce the WHOLE result of Binder#produce_arg when called" do
            ducky = interpreter(script:"x y z",
              binder:{x:int(33), y:bool(T), z:decimal(12.34)})
            ducky.run
            ducky.inspect.should == "[:x=33, 33, :y=T, T, :z=12.34, 12.34 :: :: «»]"
          end
          
          it "should be willing to produce ANYTHING found in the Binder, not just Variables" do
            ducky = interpreter(script:"+ * - 3 + length", binder:Binder.new([int(8)]))
            ducky.run
            ducky.inspect.should == "[-117, :length :: :: «»]" # 3 + 8 - (8+8) * 8
          end

          it "should work for quite complex bindings" do
            ducky = interpreter(script:"x op 2",
              binder: {x:int(3), op:message("+")})
            ducky.run
            ducky.inspect.should == "[:x=3, :op=:+, 5 :: :: «»]"
          end
        end
        
        describe "handling arrays of 'inputs'" do
          it "should handle List inputs" do
            ducky = interpreter(
              script:"x x x + +",
              binder:{x:list([int(8), bool(F)])})
            ducky.run
            ducky.inspect.should == "[:x=(8, F), (8, F, 8, F, 8, F) :: :: «»]"
          end
        end
        
        it "should 'work' for :rebind messages" do
          ducky = interpreter(script:"x x x + rebind x x x",
            binder:{x:int(8)}) 
          ducky.run
          ducky.inspect.should == "[8, 16, 16, :x=16, 16 :: :: «»]"
        end
      end
    end
  end
end
