# frozen_string_literal: true

module Sanitizers
  # makes email format consistent
  class EmailSanitizer
    class << self
      # @param email [String]
      # return [String]
      def sanitize(email)
        return email if email.nil? || email == ''

        email.downcase!
        strip_irrelevant_bits(email)
      end

      private

      def strip_irrelevant_bits(email)
        local_part, domain = email.split('@')
        local_part&.gsub!('.', '') # Remove periods
        local_part&.gsub!(/\+.*/, '') # Remove tags
        [local_part, domain].join('@')
      end
    end
  end
end
