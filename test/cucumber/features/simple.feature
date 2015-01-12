Feature: Addition
    In order to avoid silly mistakes
    As a math idiot
    I want to be told that ...

    Scenario: Add two numbers
        Given I have entered 50 into it
        And I have entered 70 again
        When I press add
        Then the result should be 120

