#encoding:utf-8
require_relative './spec_helper'

describe "the Assembler item" do
  it "should be a subclass of List" do
    Assembler.new.should be_a_kind_of(List)
  end
  
  describe ":push" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should place items that are :pushed onto its internal #buffer" do
      @s.stub!(:process_buffer) # to stop the buffer being cleared
      @s.push(Int.new(1))
      @s.buffer.length.should == 1
    end
    
    it "should be able to append multiple items to the buffer by pushing an Array" do
      @s.stub!(:process_buffer) # to stop the buffer being cleared
      @s.push [Int.new(3),Int.new(4)]
      @s.buffer.length.should == 2
      @s.buffer[0].value.should == 3
      @s.buffer[1].value.should == 4
    end
    
    it "should take items from its contents to fill the lowest staged item's #needs" do
      @s.push([Int.new(7), Decimal.new(3.5), Message.new("+")])
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[10.5]"
    end
    
    it "should work for methods that return multiple values" do
      @s.contents.push(Decimal.new(1.125))
      @s.push(Message.new("trunc"))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[1, 0.125]"
    end
    
    it "should work for methods that return nothing" do
      @s.contents.push(Message.new("+"))
      @s.contents.push(Message.new("-"))
      @s.push(Message.new("zap"))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[:+]"
    end
    
    it "should check to see if the buffered items are wanted by anything in the contents" do
      @s.contents.push(Message.new("*"))
      @s.contents.push(Int.new(-2))
      @s.push(Int.new(3))
      @s.buffer.length.should == 0
      @s.contents.inspect.should == "[-6]"
    end
    
    it "should work when the results are nil" do
      @s.contents.push(Message.new("zap"))
      @s.push([Message.new("+"), Message.new("-")])
      @s.contents.inspect.should == "[:-]"
    end
    
    it "should work when the results are an array" do
      @s.contents.push(Message.new("trunc"))
      @s.push(Decimal.new(125.125))
      @s.contents.inspect.should == "[125, 0.125]"
    end
    
    it "should return the updated Assembler" do
      @s.push(Int.new(11)).should == @s
      @s.contents.inspect.should == "[11]"
    end
    
    it "should be able to handle items already present on the buffer"
  end
  
  describe "'being on its own stack'" do
    it "should present itself as the 'bottom' item on its own stack, when processing is underway" do
      pending
      tenuous = Assembler.new
      tenuous.contents.push(Int.new(3))
      tenuous.contents.push(Int.new(4))
      result = tenuous.push(Message.new("shatter"))
      result.should be_a_kind_of(Array)
      result.inspect.should == "[3, 4]"
    end
    
  end
  
  describe "inherited methods" do
    
    describe ":count" do
      it "should respond to :count like a List does" do
        Assembler.new.count.should be_a_kind_of(Int)
        Assembler.new(*[Int.new(1)]*12).count.value.should == 12
      end

      it "should include items on the buffer"
    end
    
    describe ":[]" do
      it "should respond to :[] like a List does" do
        d = DuckInterpreter.new("3 []")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[9]"
      end
      
      it "should inclue items in the Buffer"
    end
    
    describe ":empty" do
      it "should respond to :empty like a List does" do
        Assembler.new(*[Int.new(1)]*12).empty.contents.length.should == 0
        Assembler.new(*[Int.new(1)]*12).empty.should be_a_kind_of(Assembler)
      end
      
      it "should include the buffer"
    end
    
    describe ":reverse" do
      it "should respond to :reverse like a List does" do
        d = DuckInterpreter.new("reverse")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[100, 81, 64, 49, 36, 25, 16, 9, 4, 1, 0]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should maintain the buffer untouched"
    end
    
    describe ":copy" do
      it "should respond to :copy like a List does" do
        d = DuckInterpreter.new("copy")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 100]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should copy the buffer as well"
    end
    
    describe ":swap" do
      it "should respond to :swap like a List does" do
        d = DuckInterpreter.new("swap")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 100, 81]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should leave the buffer untouched"
    end
    
    describe ":pop" do
      it "should respond to :pop like a List does" do
        d = DuckInterpreter.new("pop")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4, 9, 16, 25, 36, 49, 64, 81], 100]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should leave the buffer untouched"
    end
    
    describe ":shift" do
      it "should respond to :shift like a List does" do
        d = DuckInterpreter.new("shift")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100], 0]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should leave the buffer untouched"
    end

    describe ":unshift" do
      it "should respond to :unshift like a List does" do
        d = DuckInterpreter.new("F unshift")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[F, 0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should leave the buffer untouched, somehow???"
    end
    
    
    describe ":shatter" do
      it "should respond to :shatter like a List does" do
        d = DuckInterpreter.new("shatter")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100]"
      end
      
      it "should release the buffered items as well"
    end
    
    describe ":[]=" do
      it "should respond to :[]= like a List does" do
        d = DuckInterpreter.new("4 F []=")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4, 9, F, 25, 36, 49, 64, 81, 100]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should include the buffer as elements for replacement"
    end
    
    
    describe ":useful" do
      it "should respond to :useful like a List does, but return Lists" do
        d = DuckInterpreter.new("* useful")
        items = [Bool.new(false), Int.new(2), Int.new(4)]
        d.stack.push(Assembler.new(*items))
        d.run
        d.stack.inspect.should == "[[2, 4], [F]]"
        d.stack[0].should be_a_kind_of(List)
        d.stack[1].should be_a_kind_of(List)
      end
      
      it "does should check the buffer as well"
    end
    
    describe ":users" do
      it "should respond to :users like a List does, but return Lists" do
        d = DuckInterpreter.new("3.1 users")
        items = [Message.new("+"), Message.new("inc"), Message.new("empty")]
        d.stack.push(Assembler.new(*items))
        d.run
        d.stack.inspect.should == "[[:+], [:inc, :empty]]"
        d.stack[0].should be_a_kind_of(List)
        d.stack[1].should be_a_kind_of(List)
      end
      
      it "should check the buffer as well"
    end
    
    describe ":∪" do
      it "should respond to :∪ like a List does" do
        d = DuckInterpreter.new("∪")
        list1 = [Bool.new(false), Int.new(2), Int.new(4)]
        list2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
        d.stack.push(Assembler.new(*list1))
        d.stack.push(Assembler.new(*list2))
        d.run
        d.stack.inspect.should == "[[F, 2, 4, T, 4.0]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should compare the buffer elements as well as stacked ones, unbuffering them"
    end
    
    
    describe ":∩" do
      it "should respond to :∩ like a List does" do
        d = DuckInterpreter.new("∩")
        list1 = [Bool.new(false), Int.new(2), Int.new(4)]
        list2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
        d.stack.push(Assembler.new(*list1))
        d.stack.push(Assembler.new(*list2))
        d.run
        d.stack.inspect.should == "[[2]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should compare the buffer elements as well as the stack ones, unbuffering them"
    end
    
    describe ":flatten" do
      it "should respond to :flatten like a List does" do
        d = DuckInterpreter.new("flatten")
        subtree_1 = [Bool.new(false), Int.new(2), Int.new(4)]
        subtree_2 = [Bool.new(true), Int.new(2), Decimal.new(4.0)]
        tree = subtree_1 + [Assembler.new(*subtree_2+[List.new(*subtree_1)])] + [List.new(*subtree_1)]
        d.stack.push(Assembler.new(*tree))
        d.run
        d.stack.inspect.should == "[[F, 2, 4, T, 2, 4.0, (F, 2, 4), F, 2, 4]]"
        d.stack[0].should be_a_kind_of(Assembler)
      end
      
      it "should include the buffer items in the result"
    end
    
    describe ":snap" do
      it "should respond to :snap like a List does" do
        d = DuckInterpreter.new("3 snap")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4], [9, 16, 25, 36, 49, 64, 81, 100]]"
        d.stack[0].should be_a_kind_of(Assembler)
        d.stack[1].should be_a_kind_of(Assembler)
      end
      
      it "should count the buffer as part of the contents for counting, and share it out"
      # [1 2 3 4 : 5 6], if snapped between 5 and 6 in buffer, would make:
      # [1 2 3 4 : 5] and [ : 6], leaving 6 on the buffer of the second (empty) Assembler
    end
    
    describe ":rewrap_by" do
      it "should respond to :rewrap_by like a List does" do
        d = DuckInterpreter.new("3 rewrap_by")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[0, 1, 4], [9, 16, 25], [36, 49, 64], [81, 100]]"
        d.stack.each {|i| i.should be_a_kind_of(Assembler)}      
      end
      
      it "should do something reasonable with the buffer :/"
    end
    
    describe ":rotate" do
      it "should respond to :rotate like a List does" do
        d = DuckInterpreter.new("rotate")
        numbers = (0..10).collect {|i| Int.new(i*i)}
        d.stack.push(Assembler.new(*numbers))
        d.run
        d.stack.inspect.should == "[[1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 0]]"
        d.stack.each {|i| i.should be_a_kind_of(Assembler)}      
      end
      
      it "should NOT include the buffer in the rotation"
    end
  end
  
  describe "special behaviors" do
    it "should act differently from a List when responding to :+"
    it "should act differently from a List when responding to :give"
    it "should act differently from a List when responding to :map"
  end
  
  describe "visualization" do
    before(:each) do
      @s = Assembler.new
    end
    
    it "should look like an Array" do
      @s.push(Int.new(7))
      @s.push(Int.new(3))
      @s.inspect.should == "[7, 3]"
    end
  end
end