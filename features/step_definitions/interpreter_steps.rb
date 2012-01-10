Given /^the Script is "([^"]*)"$/ do |arg1|
  @script = arg1
  @interpreter = DuckInterpreter.new(@script)
end

When /^the Script is run$/ do
  @interpreter.run
end

Then /^the top Stack item should be ([-+]?\d+)$/ do |arg1|
  @interpreter.stack[-1].value.to_s.should == arg1
end

Then /^the bottom Stack item should be ([-+]?\d+)$/ do |arg1|
  @interpreter.stack[0].value.to_s.should == arg1
end

Then /^the Stack should be empty$/ do
  @interpreter.stack.length.should == 0
end
