Feature: The executable provides correct success status

Scenario: When running with unsupported options
  When I run `person_matcher.rb -x -a same_email -f ../../spec/fixtures/minimal.csv`
  Then the exit status should be 1

Scenario: When missing the algorithm argument
  When I run `person_matcher.rb -a`
  Then the exit status should be 2

Scenario: When running without an algorithm option
  When I run `person_matcher.rb -f some_file.csv`
  Then the exit status should be 3

Scenario: When running with an unsupported algorithm
  When I run `person_matcher.rb -a unsupported -f some_file.csv`
  Then the exit status should be 4

Scenario: When running without a source file option
  When I run `person_matcher.rb -a same_email`
  Then the exit status should be 5

Scenario: When running on a file that doesn't exist
  When I run `person_matcher.rb -a same_email -f file_does_not_exist.csv`
  Then the exit status should be 6

Scenario: When running on a file that doesn't have read permission
  Given a file that is unreadable
  When I run `person_matcher.rb -a same_email -f unreadable.csv`
  Then the exit status should be 7

Scenario: When running on a malformed csv
  When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/malformed.csv`
  Then the exit status should be 8

Scenario: When running on a csv with no matching columns
  When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/no_matching_column.csv`
  Then the exit status should be 9

Scenario: When writing the output to a dir without write permission
  Given a folder that is not writeable
  When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/minimal.csv`
  Then the exit status should be 10
