Feature: Parser should recognize integers

  Scenario: simple scripts
    Given the script is "1 2 34 -45 -991"
    When the Script is run
    Then the top Stack item should be -991
    And the bottom Stack item should be 1
  
  
  