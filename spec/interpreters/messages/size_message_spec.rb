require_relative '../../spec_helper'

describe "Interpreter" do
  describe "the :size message" do
    it "should be recognized" do
      Interpreter.recognized_messages.should include(:size)
    end
    
    it "should be 4 for an empty Interpreter (binder (incl. proxy!) + script + self)" do
      Interpreter.new.size[1].value.should == 4
    end
    
    it "should be a total of the #size results from contents + buffer + script + binder, plus itself" do
      wordy = "foo bar baz"
      bindy = Binder.new([int(22), int(33)])
      tree = list([list([int(1)]), assembler(contents:[int(8)])])
      line = list([int(1), int(2), int(3)])
      
      all = interpreter(contents:[line], buffer:[tree], script:wordy, binder:bindy)
      all.script.size[1].value.should == 12
      all.binder.size[1].value.should == 4 #includes the inserted proxy!
      
      all.size[1].value.should == 
        tree.size[1].value +
        line.size[1].value +
        script(wordy).size[1].value +
        bindy.size[1].value +
        1
    end
  end
end
