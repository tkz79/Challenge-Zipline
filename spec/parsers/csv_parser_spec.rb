# frozen_string_literal: true

require 'parsers/csv_parser'

RSpec.describe 'Parsers::CsvParser' do
  let(:csv_parser) { Parsers::CsvParser.new(algorithm_definitions, dictionary, source_csv_path) }
  let(:algorithm_definitions) { Config.algorithm_definitions(algorithm) }
  let(:algorithm) { 'same_phone' }
  let(:dictionary) { Models::Dictionary.new }
  let(:source_csv_path) { "#{fixture_path}minimal.csv" }
  let(:fixture_path) { 'spec/fixtures/' }

  describe '#new' do
    it 'is initialized correctly' do
      expect(csv_parser.algorithm_definitions).to be(algorithm_definitions)
      expect(csv_parser.dictionary).to be(dictionary)
      expect(csv_parser.source_csv_path).to be(source_csv_path)
    end
  end

  describe('#parse') do
    before { allow(dictionary).to receive(:process_row) }

    context 'when matching column is found' do
      let(:algorithm) { 'same_phone' }
      let(:source_csv_path) { "#{fixture_path}minimal.csv" }

      it 'calls the dictionary to process a row twice' do
        expect(dictionary).to receive(:process_row).twice
        csv_parser.parse
      end
    end

    context 'when using hard coded column feature' do
      let(:algorithm) { 'same_phone' }
      let(:source_csv_path) { "#{fixture_path}column_named_mobile.csv" }
      let(:algorithm_definitions) do
        [
          {
            columns: %w[mobile],
            label: 'phone',
            regex: /^phone/i,
            sanitizer: Sanitizers::PhoneSanitizer
          }
        ].freeze
      end

      it 'is able to identify the phone column named Mobile' do
        expect(dictionary).to receive(:process_row).with(['phone:15551234567'])
        csv_parser.parse
      end
    end

    context 'when source file is malformed' do
      let(:algorithm) { 'same_email_or_phone' }
      let(:source_csv_path) { "#{fixture_path}malformed.csv" }

      it 'raises a MalformedCSVError exception' do
        expect { csv_parser.parse }.to raise_error(CSV::MalformedCSVError)
      end
    end

    context 'when source file is missing read permission' do
      let(:algorithm) { 'same_email_or_phone' }
      let(:source_csv_path) { "#{fixture_path}bad_permissions.csv" }

      it 'raises an EACCES exception' do
        File.chmod(0o100, source_csv_path)
        expect { csv_parser.parse }.to raise_error(Errno::EACCES)
        File.chmod(0o644, source_csv_path)
      end
    end

    context 'when source file not found' do
      let(:algorithm) { 'same_email_or_phone' }
      let(:source_csv_path) { "#{fixture_path}missing_file.csv" }

      it 'raises an ENOENT exception' do
        expect { csv_parser.parse }.to raise_error(Errno::ENOENT)
      end
    end

    context 'when no matching column is found' do
      let(:algorithm) { 'same_email_or_phone' }
      let(:source_csv_path) { "#{fixture_path}no_matching_column.csv" }

      it 'raises a ColumnNotFound exception' do
        expect { csv_parser.parse }.to raise_error(ColumnNotFound)
      end
    end
  end
end
