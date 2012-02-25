#encoding: utf-8
require_relative '../../spec_helper'

describe "Iterator" do
  describe "inherited List methods" do
    describe ":[]" do
      it "should respond to [] as a List does, returning an element of the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"[] 2", contents:[itty]).run.inspect.should ==
          "[-99 :: :: «»]"
      end
    end
    
    
    describe ":[]=" do
      it "should respond to []= as a List does, setting an element of the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"1 []= 8", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[F, 8, -99] :: :: «»]"
      end
    end
    
    
    describe ":+" do
      it "should respond to :+ as a List does, concatenating the contents into itself" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        bitty = Iterator.new(start:1, end:-22, contents:[message(:bar)])
        
        interpreter(script:"+", contents:[bitty, itty]).run.inspect.should ==
          "[(3..3..11)=>[F, :foo, -99, :bar] :: :: «»]"
      end
    end
    
    
    describe ":copy" do
      it "should respond to :copy as a List does, duplicating the top item" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"copy", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[F, :foo, -99, -99] :: :: «»]"
      end
    end
    
    
    describe ":empty" do
      it "should respond to :empty as a List does, clearing the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"empty", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[] :: :: «»]"
      end
    end
    
    
    describe ":emit" do
      it "should respond to :emit as a List does, popping a respondent to a message" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"¬ emit ", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[:foo, -99], F :: :: «»]"
      end
    end
    
    
    describe ":flatten" do
      it "should respond to :flatten as a List does, flattening the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        teeny = Iterator.new(start:2, end:3, contents:[itty,itty])
        
        interpreter(script:"flatten ", contents:[teeny]).run.inspect.should ==
          "[(2..2..3)=>[F, :foo, -99, F, :foo, -99] :: :: «»]"
      end
    end
    
    
    describe ":fold_down" do
      it "should respond to :fold_down as a List does, collapsing the contents on themselves" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"fold_down", contents:[itty]).run.inspect.should ==
          "[-99 :: :: «»]"
      end
    end
    
    
    describe ":fold_up" do
      it "should respond to :fold_up as a List does, collapsing the contents on themselves" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"fold_up", contents:[itty]).run.inspect.should ==
          "[F :: :: «»]"
      end
    end
    
    
    describe ":give" do
      it "should respond to :give as a List does, passing the arg to each element" do
        itty = Iterator.new(start:3, end:11, contents:[message(:+), message(:foo), int(-99)])
        interpreter(script:"give 8", contents:[itty]).run.inspect.should ==
          "[(λ(8 + ?,[\"neg\"]), :foo, -99) :: :: «»]"
      end
    end
    
    
    describe ":infold_down" do
      it "should respond to :infold_down as a List does, passing the arg to each element in turn" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"infold_down be", contents:[itty]).run.inspect.should ==
          "[F :: :: «»]"
      end
    end
    
    
    describe ":infold_up" do
      it "should respond to :infold_up as a List does, passing the arg to each element in turn" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"infold_up be", contents:[itty]).run.inspect.should ==
          "[-99 :: :: «»]"
      end
    end
    
    
    
    describe ":length" do
      it "should respond to :length as a List does, returning the number of items in the root contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        interpreter(script:"length ", contents:[itty]).run.inspect.should ==
          "[3 :: :: «»]"
      end
    end
    
    
    describe ":map" do
      it "should respond to :map as a List does, passing the arg to each element" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"map do", contents:[itty]).run.inspect.should ==
          "[(:do, :foo, :do) :: :: «»]"
      end
    end
    
    
    describe ":pop" do
      it "should respond to :pop as a List does, popping off the top item of contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"pop", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[F, :foo], -99 :: :: «»]"
      end
    end
    
    
    describe ":push" do
      it "should respond to :push as a List does, push some item onto contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"bar push", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[F, :foo, -99, :bar] :: :: «»]"
      end
    end
    
    
    describe ":reverse" do
      it "should respond to :reverse as a List does, push some item onto contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"reverse", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[-99, :foo, F] :: :: «»]"
      end
    end
    
    
    describe ":rotate" do
      it "should respond to :reverse as a List does, rotating the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"rotate", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[:foo, -99, F] :: :: «»]"
      end
    end
    
    
    describe ":shift" do
      it "should respond to :shift as a List does, shifting an item off the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"shift", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[:foo, -99], F :: :: «»]"
      end
    end
    
    
    describe ":swap" do
      it "should respond to :swap as a List does, switching the top two items of contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"swap", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[F, -99, :foo] :: :: «»]"
      end
    end
    
    
    describe ":unshift" do
      it "should respond to :unshift as a List does, unshifting an item onto the contents" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"T unshift", contents:[itty]).run.inspect.should ==
          "[(3..3..11)=>[T, F, :foo, -99] :: :: «»]"
      end
    end
    
    
    describe ":useful" do
      it "should respond to :useful as a List does, returning two lists of contents items" do
        itty = Iterator.new(start:3, end:11, contents:[bool(F), message(:foo), int(-99)])
        
        interpreter(script:"- useful", contents:[itty]).run.inspect.should ==
          "[(-99), (F, :foo) :: :: «»]"
      end
    end
    
    
    describe ":users" do
      it "should respond to :users as a List does, returning two lists of contents items" do
        batty = Iterator.new(start:3, end:11, contents:[message(:*), message(:length), int(2).+])
        interpreter(script:"12 users", contents:[batty]).run.inspect.should ==
          "[(:*, λ(2 + ?,[\"neg\"])), (:length) :: :: «»]"
      end
    end
  end
end
