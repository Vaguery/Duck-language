Given /^the script is "([^"]*)"$/ do |arg1|
  @script = arg1
  @interpreter = DuckInterpreter.new(@script)
end

When /^the Script is run$/ do
  @interpreter.run
end

Then /^the top Stack item should be \-(\d+)$/ do |arg1|
end

Then /^the bottom Stack item should be (\d+)$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end
