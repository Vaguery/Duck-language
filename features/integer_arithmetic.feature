Feature: Integer arithmetic

  Scenario: integers do addition correctly
    Given the Script is "1 2 add"
    When the Script is run
    Then the top Stack item should be 3
  
  
  Scenario: integer do subtraction correctly
    Given the Script is "11 22 -"
    When the Script is run
    Then the top Stack item should be -11
  
  
  