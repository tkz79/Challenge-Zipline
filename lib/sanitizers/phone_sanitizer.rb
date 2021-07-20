# frozen_string_literal: true

module Sanitizers
  # makes phone format consistent
  class PhoneSanitizer
    class << self
      # @param phone [String]
      # return [String]
      def sanitize(phone)
        return phone if phone.nil? || phone == ''

        strip_non_numerics(phone)
        ensure_country_code_present(phone)
      end

      private

      # @param phone [String]
      def strip_non_numerics(phone)
        phone.gsub!(/[^0-9]/, '')
      end

      # @param phone [String]
      def ensure_country_code_present(phone)
        return "1#{phone}" if phone.length == 10

        phone
      end
    end
  end
end
