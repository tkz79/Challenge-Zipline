# frozen_string_literal: true

Dir[File.join(__dir__, 'sanitizers', '*.rb')].each { |sanitizer| require sanitizer } # rubocop:disable Lint/NonDeterministicRequireOrder

# Config file to add / confgiure algorithms
class Config
  VERSION = '1.0.0'

  ALGORITHMS = %w[
    same_email
    same_phone
    same_email_or_phone
  ].freeze

  SAME_EMAIL = [
    {
      columns: %w[], # Hard code additional column names
      label: 'email',
      regex: /^email/i, # Search pattern to identify columns
      sanitizer: Sanitizers::EmailSanitizer
    }
  ].freeze

  SAME_PHONE = [
    {
      columns: %w[], # Hard code additional column names
      label: 'phone',
      regex: /^phone/i, # Search pattern to identify columns
      sanitizer: Sanitizers::PhoneSanitizer
    }
  ].freeze

  SAME_EMAIL_OR_PHONE = [SAME_EMAIL, SAME_PHONE].flatten.freeze

  def self.algorithm_definitions(algorithm_code)
    const_get(algorithm_code.upcase)
  end
end
