# frozen_string_literal: true

require 'securerandom'

module Writers
  # Creates a csv file with the results
  class CsvWriter
    attr_reader :algorithm_definitions, :dictionary, :output_file, :source_csv_path

    def initialize(algorithm, algorithm_definitions, dictionary, source_csv_path)
      @algorithm_definitions = algorithm_definitions
      @dictionary = dictionary
      @source_csv_path = source_csv_path

      time_stamp = Time.now.to_i
      file_name = "output_#{time_stamp}_#{algorithm}.csv"
      @output_file = File.new(file_name, 'w')
    end

    def write
      write_header_row
      write_data_rows

      output_file.close
    end

    private

    def write_header_row
      headers = CSV.open(source_csv_path, 'r') { |csv| csv.first }
      output_file.puts(headers.unshift('matching_id').join(','))
    end

    def write_data_rows
      CSV.foreach(source_csv_path, headers: true) do |row|
        new_row = [fetch_uuid(row)]
        new_row << row.to_hash.values
        output_file.puts(new_row.join(','))
      end
    end

    # @param csv_row [CvsRow]
    # @return [String]
    def fetch_uuid(csv_row)
      parsed_row = Parsers::CsvRowParser.new(algorithm_definitions, csv_row).parse
      dictionary.uuid_lookup(parsed_row.first)
    end
  end
end
