# frozen_string_literal: true

module Sanitizers
  # For any matching algorithms that don't need any sanitization
  class BlankSanitizer
    class << self
      # @param value [String]
      # return [String]
      def sanitize(value)
        value
      end
    end
  end
end
