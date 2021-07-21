# frozen_string_literal: true

Then('a file that is unreadable') do
  setup_aruba
  Dir.chdir('tmp/aruba') do
    File.open('unreadable.csv', 'w')
    FileUtils.chmod(0o000, 'unreadable.csv')
  end
end
