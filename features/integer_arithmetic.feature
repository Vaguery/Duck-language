Feature: Integer arithmetic

  Scenario: scripts can represent addition in traditional postfix/Forth style
    Given the Script is "10 2 + 3 - 8 * 6 /"
    When the Script is run
    Then the top Stack item should be 12
    
    
  Scenario: it will run any script composed of {+, *, -, /, k}, for k integer
    Given a list of 1000 random Scripts
    Then all the Scripts will run
  
  
  