#encoding: utf-8
require_relative '../../spec_helper'

describe "Message" do
  describe ":bind" do
    it "should be NOT recognized by a Message object" do
      Message.recognized_messages.should_not include :bind
    end
  end
end
