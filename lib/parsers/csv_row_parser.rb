# frozen_string_literal: true

module Parsers
  # Parses Individual CSV Row
  class CsvRowParser
    attr_reader :algorithm_definitions, :csv_row

    # @param algorithm_definitions [Array] of [Hash] ex: [{ label: 'email', regex: /^email/i, sanitizer: Sanitizers::EmailSanitizer }]
    # @param row [CsvRow]
    def initialize(algorithm_definitions, csv_row)
      @algorithm_definitions = algorithm_definitions
      @csv_row = csv_row
    end

    # @return [Array] of [String] ex: ['email:johnd@home.com', 'phone:5551234567', 'phone:5559876543']
    def parse
      labeled_values = {}
      algorithm_definitions.each do |definition|
        matching_columns = select_columns(definition)
        sanitized_values = sanitize_values(definition[:sanitizer], matching_columns.values)
        labeled_values[definition[:label]] = sanitized_values if sanitized_values.any?
      end

      flatten_hash(labeled_values)
    end

    private

    # @param definition [Config::SAME_EMAIL || Config::SAME_PHONE || Config::SAME_EMAIL_OR_PHONE]
    # Selects columns that match the algorithm definition's regex or are included in the column list
    def select_columns(definition)
      csv_row.to_hash.select { |key, _| definition[:regex] =~ key || definition[:columns].include?(key.downcase) }
    end

    # @param sanitizer [Sanitizers::EmailSanitizer || Sanitizers::PhoneSanitizer]
    # @param values [Array] of [String]
    # @return [Array] of [String]
    def sanitize_values(sanitizer, values)
      values.map do |value|
        sanitized_value = sanitizer.sanitize(value)
        sanitized_value unless sanitized_value == ''
      end.compact
    end

    # @param labeled_hash [Hash] ex: { 'email'=>['johnd@home.com'], 'phone'=>['5551234567', '5559876543'] }
    # @return [Array] of [String] ex: ['email:johnd@home.com', 'phone:5551234567', 'phone:5559876543']
    def flatten_hash(labeled_hash)
      labeled_hash.map do |key, values|
        values.map { |value| "#{key}:#{value}" }
      end.flatten
    end
  end
end
