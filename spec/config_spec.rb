# frozen_string_literal: false

RSpec.describe 'Config' do
  let(:config) { Config }

  describe 'ALGORITHMS' do
    it 'returns all the known algorithms' do
      expect(config::ALGORITHMS).to eq(%w[same_email same_phone same_email_or_phone])
    end
  end

  describe '#algorithm_definitions' do
    let(:same_email) do
      [
        {
          columns: %w[], # Hard code additional column names
          label: 'email',
          regex: /^email/i, # Search pattern to identify columns
          sanitizer: Sanitizers::EmailSanitizer
        }
      ].freeze
    end
    let(:same_phone) do
      [
        {
          columns: %w[], # Hard code additional column names
          label: 'phone',
          regex: /^phone/i, # Search pattern to identify columns
          sanitizer: Sanitizers::PhoneSanitizer
        }
      ]
    end
    let(:same_email_or_phone) { [same_email, same_phone].flatten }

    context 'when algorithm is same_email' do
      it 'returns the same_email algorithm definition' do
        expect(config.algorithm_definitions('same_email')).to eq(same_email)
      end
    end

    context 'when algorithm is same_phone' do
      it 'returns the same_phone algorithm definition' do
        expect(config.algorithm_definitions('same_phone')).to eq(same_phone)
      end
    end

    context 'when algorithm is same_email_or_phone' do
      it 'returns the same_email_or_phone algorithm definition' do
        expect(config.algorithm_definitions('same_email_or_phone')).to eq(same_email_or_phone)
      end
    end
  end
end
