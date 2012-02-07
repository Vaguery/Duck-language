#encoding:utf-8
require_relative '../../spec_helper'

describe "Variable" do
  describe ":rebind" do
    it "should be recognized by a Variable item" do
      Variable.recognized_messages.should include(:rebind)
    end
    
    it "should produce a Closure looking for any item" do
      v_gone = Variable.new("foo", Int.new(9)).rebind
      v_gone.should be_a_kind_of(Closure)
      v_gone.needs.should == ["be"]
      v_gone.inspect.should == "λ(foo.bind(?),[\"be\"])"
    end
  end
end
