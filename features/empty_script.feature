Feature: Empty script

Scenario: empty script should produce an empty stack
  Given the Script is ""
  When the Script is run
  Then the Stack should be empty



  
