Feature: The executable provides correct success status

Scenario: When running with same_email algorithm and file
  When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/minimal.csv`
  Then the exit status should be 0

Scenario: When running with same_phone algorithm and file
  When I run `person_matcher.rb -a same_phone -f ../../spec/fixtures/minimal.csv`
  Then the exit status should be 0

Scenario: When running with same_email_or_phone algorithm and file
  When I run `person_matcher.rb -a same_email -f ../../spec/fixtures/minimal.csv`
  Then the exit status should be 0

Scenario: When checking the options
  When I run `person_matcher.rb --help`
  Then the exit status should be 0

Scenario: When checking the options
  When I run `person_matcher.rb -h`
  Then the exit status should be 0

Scenario: When running with --version option
  When I run `person_matcher.rb --version`
  Then the exit status should be 0

Scenario: When running with -v option
  When I run `person_matcher.rb -v`
  Then the exit status should be 0
