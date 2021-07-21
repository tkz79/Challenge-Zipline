# frozen_string_literal: true

require 'models/identifiable'
require 'securerandom'

module Models
  # Unique identifer that maintains a list of known identifiables
  class Identifier
    attr_reader :identifiables, :uuid

    def initialize
      @uuid = SecureRandom.uuid
      @identifiables = {}
    end

    # @param identifiers [Array] of [Models::Identifiable]
    def add_identifiables(new_identifiables)
      new_identifiables.each { |identifiable| identifiables[identifiable.value] = identifiable }
    end

    # @param identifiers [Array] of [Models::Identifier]
    def merge(identifiers)
      identifiables_to_merge = identifiers.map(&:identifiables).reduce({}, :merge)
      identifiables_to_merge.each_value { |identifiable| identifiable.update_identifier(self) }
      identifiables.merge!(identifiables_to_merge)
    end
  end
end
