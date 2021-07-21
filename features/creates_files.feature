Feature: The executable creates files

  Scenario: creates an output file on completion
    When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/minimal.csv`
    Then a csv output file should exist
