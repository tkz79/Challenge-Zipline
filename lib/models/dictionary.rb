# frozen_string_literal: true

require 'models/indentifier'

module Models
  # Data store for known values
  class Dictionary
    attr_reader :identifiables

    def initialize
      @identifiables = {}
    end

    # @param row_data [Array] ex: ["email:johnd@home.com", "phone:5551234567", "phone:5559876543"
    def process_row(identifiable_values)
      matching_identifiables = identifiables.slice(*identifiable_values)
      matching_identifiers = matching_identifiables.values.map(&:identifier).uniq

      case matching_identifiers.count
      when 0
        identifier = Models::Identifier.new
      when 1
        identifier = matching_identifiers.first
      else
        identifier = matching_identifiers.first
        identifier.merge(matching_identifiers[1..])
      end

      new_values = identifiable_values - matching_identifiables.keys
      new_identifiables = create_identifiables(identifier, new_values)

      identifier.add_identifiables(new_identifiables)
    end

    # @param parsed_row [String] ex: 'email:johnd@home.com'
    # @return [Models::Identifier]
    def uuid_lookup(identifiable_key)
      return SecureRandom.uuid if identifiable_key.nil? || identifiable_key.gsub(' ', '') == '' # Only rows with a value are in the dictionary

      identifiables[identifiable_key].identifier.uuid
    end

    private

    # @param identifier [Models::Identifier]
    # @param new_values [Array] of [String] ex ["email:johnd@home.com", "phone:5551234567", "phone:5559876543"]
    # @return [Array]
    def create_identifiables(identifier, new_values)
      new_identifiables = new_values.map { |value| Models::Identifiable.new(identifier, value) }
      new_identifiables.each { |identifiable| identifiables[identifiable.value] = identifiable }

      new_identifiables
    end
  end
end
