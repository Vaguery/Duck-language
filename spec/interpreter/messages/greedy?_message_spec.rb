require_relative '../../spec_helper'

describe "Interpreter" do
  describe ":greedy?" do
    it "should be possible to read the greedy state via the :greedy? message" do
      d = DuckInterpreter.new("greedy?").run
      d.stack.inspect.should == "[T]"
    end
  end
end