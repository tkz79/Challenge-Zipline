# frozen_string_literal: true

require 'config'
require 'csv'
require 'exceptions'
require 'models/dictionary'
require 'parsers/csv_row_parser'

module Parsers
  # Parses the CSV file one line a time
  class CsvParser
    attr_reader :algorithm, :algorithm_definitions, :dictionary, :source_csv_path

    # @param algorithm_definitions [Array] of [Hash]
    # @param dictionary [Models::Dictionary]
    # @param source_csv_path [String]
    def initialize(algorithm_definitions, dictionary, source_csv_path)
      @algorithm_definitions = algorithm_definitions
      @dictionary = dictionary
      @source_csv_path = source_csv_path
    end

    def parse
      validate_identifiable_column
      parse_rows

      dictionary
    end

    private

    def validate_identifiable_column
      headers = CSV.open(source_csv_path, 'r') { |csv| csv.first }

      algorithm_definitions.each do |definition|
        return true if headers.select { |header| definition[:regex] =~ header || definition[:columns].include?(header&.downcase) }.any?
      end

      raise ColumnNotFound.new, 'CSV does not contain a column matching your algorithm'
    end

    def parse_rows
      CSV.foreach(source_csv_path, headers: true) do |row|
        parsed_values = Parsers::CsvRowParser.new(algorithm_definitions, row).parse
        dictionary.process_row(parsed_values) if parsed_values.any?
      end
    end
  end
end
