def random_script(tokens=["+","*","-","/","k","k","k","k","k","k","k","k"],length=20)
  length.times.inject(" ") do |script,token|
    script += " #{tokens.sample.gsub(/k/,(rand(100)-50).to_s)}"
  end
end

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

Given /^a list of (\d+) random Scripts$/ do |arg1|
  how_many = arg1.to_i
  @lots_of_scripts = how_many.times.collect {random_script}
end

Then /^all the Scripts will run$/ do
  @lots_of_scripts.each do |s|
    lambda { DuckInterpreter.new(s).run }.should_not raise_error
  end
end