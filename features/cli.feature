Feature: The executable has a good command-line interface

  Scenario: Checking that the options are documented
    When I run `person_matcher.rb -h`
    Then the output should contain:
    """
    Usage: bin/person_matcher.rb (-a ALGORITHM -f FILEPATH | -h | -v)
    """

  Scenario: Prints messages in verbose mode
    When I run `person_matcher.rb --version`
    Then the output should contain:
    """
    1.0.0
    """
