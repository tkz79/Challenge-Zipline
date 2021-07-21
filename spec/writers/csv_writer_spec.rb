# frozen_string_literal: true

require 'aruba/rspec'
require 'writers/csv_writer'

RSpec.describe 'Writers::CsvWriter', type: :aruba do
  let(:csv_writer) { Writers::CsvWriter.new(algorithm, algorithm_definitions, dictionary, source_csv_path) }
  let(:algorithm_definitions) { Config.algorithm_definitions(algorithm) }
  let(:algorithm) { 'same_phone' }
  let(:dictionary) { Models::Dictionary.new }
  let(:source_csv_path) { "#{fixture_path}minimal.csv" }
  let(:fixture_path) { '../../spec/fixtures/' }

  before do
    setup_aruba
    Dir.chdir('tmp/aruba')
  end

  after { Dir.chdir('../..') }

  describe '#new' do
    it 'is initialized correctly' do
      expect(csv_writer.algorithm_definitions).to be(algorithm_definitions)
      expect(csv_writer.dictionary).to be(dictionary)
      expect(csv_writer.output_file).to be_a(File)
      expect(csv_writer.source_csv_path).to be(source_csv_path)
    end
  end

  describe '#write' do
    let(:expected_header) { %w[matching_id FirstName LastName Phone Email Zip] }
    let(:expected_row_1) { %w[John Smith 15551234567 johns@home.com 94105] }
    let(:expected_row_2) { %w[Jane Smith 17771234567 janes@home.com 94105] }

    let(:uuid_regex) { /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i }

    before { Parsers::CsvParser.new(algorithm_definitions, dictionary, source_csv_path).parse }

    it 'writes a csv file correctly' do
      csv_writer.write
      result = CSV.read(csv_writer.output_file)

      header = result[0]
      expect(header).to eq(expected_header)

      row_1 = result[1]
      expect(uuid_regex =~ row_1[0]).to be(0)
      expect(row_1[1..]).to eq(expected_row_1)

      row_2 = result[2]
      expect(uuid_regex =~ row_2[0]).to be(0)
      expect(row_2[1..]).to eq(expected_row_2)
    end
  end
end
