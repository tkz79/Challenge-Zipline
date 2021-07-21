# frozen_string_literal: true

module Models
  # Individual entry of an idendtifiable string
  class Identifiable
    attr_reader :identifier, :value

    # @param identifier [Models::Identifiable]
    # @param value [String]
    def initialize(identifier, value)
      @identifier = identifier
      @value = value
    end

    # @param identifier [Models::Identifiable]
    def update_identifier(new_identifier)
      @identifier = new_identifier
    end
  end
end
