# frozen_string_literal: true

require 'parsers/csv_row_parser'

RSpec.describe 'Parsers::CsvRowParser' do
  let(:csv_row_parser) { Parsers::CsvRowParser.new(algorithm_definitions, csv_row) }
  let(:algorithm_definitions) { Config.algorithm_definitions(algorithm) }
  let(:csv_row) { CSV.parse(fields, headers: headers).first }
  let(:fields) { 'Vera,Sandoval,1-855-404-7690,414-697-5481,Ali.quam.fringilla@morbi.co.uk,non+tag@pellentesque.co.uk,E9 8SL' }
  let(:headers) { %i[FirstName LastName Phone_1 Phone_2 Email_1 Email_2 Zip] }

  describe '#new' do
    let(:algorithm) { 'same_phone' }

    it 'is initialized correctly' do
      expect(csv_row_parser.algorithm_definitions).to be(algorithm_definitions)
      expect(csv_row_parser.csv_row).to be(csv_row)
    end
  end

  describe('#parse') do
    context 'when algorithm is same_email' do
      let(:algorithm) { 'same_email' }
      let(:expected_result) { ['email:aliquamfringilla@morbi.co.uk', 'email:non@pellentesque.co.uk'] }

      it 'parses the csv row correctly' do
        expect(csv_row_parser.parse).to eq(expected_result)
      end
    end

    context 'when algorithm is same_phone' do
      let(:algorithm) { 'same_phone' }
      let(:expected_result) { ['phone:18554047690', 'phone:14146975481'] }

      it 'parses the csv row correctly' do
        expect(csv_row_parser.parse).to eq(expected_result)
      end
    end

    context 'when algorithm is same_email_or_phone' do
      let(:algorithm) { 'same_email_or_phone' }
      let(:expected_result) { ['email:aliquamfringilla@morbi.co.uk', 'email:non@pellentesque.co.uk', 'phone:18554047690', 'phone:14146975481'] }

      it 'parses the csv row correctly' do
        expect(csv_row_parser.parse).to eq(expected_result)
      end
    end
  end
end
