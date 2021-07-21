# frozen_string_literal: false

require 'sanitizers/email_sanitizer'

RSpec.describe 'Sanitizers::EmailSanitizer' do
  let(:sanitizer) { Sanitizers::EmailSanitizer }

  describe '#sanitize' do
    context 'when string is blank' do
      it 'handles a nil value' do
        expect(sanitizer.sanitize(nil)).to eq(nil)
      end

      it 'handles an empty string value' do
        expect(sanitizer.sanitize('')).to eq('')
      end
    end

    context 'when string is not blank' do
      it 'downcases' do
        expect(sanitizer.sanitize('JACK@HOME.COM')).to eq('jack@home.com')
      end

      it 'removes periods from the local component' do
        expect(sanitizer.sanitize('j.a.c.k@home.com')).to eq('jack@home.com')
      end

      it 'removes tags from the local component' do
        expect(sanitizer.sanitize('jack+sometag@home.com')).to eq('jack@home.com')
      end
    end
  end
end
