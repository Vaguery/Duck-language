Feature: Integer arithmetic

  Scenario: scripts can represent arithmetic in traditional postfix/Forth style
    Given the Script is "10 2 - 3 - 8 +"
    When the Script is run
    Then the top Stack item should be 13