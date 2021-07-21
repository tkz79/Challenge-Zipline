# frozen_string_literal: true

Then('a csv output file should exist') do
  expect(Dir.glob('tmp/aruba/output_*.csv').any?).to be_truthy
end
