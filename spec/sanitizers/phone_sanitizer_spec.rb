# frozen_string_literal: false

require 'sanitizers/phone_sanitizer'

RSpec.describe 'Sanitizers::PhoneSanitizer' do
  let(:sanitizer) { Sanitizers::PhoneSanitizer }

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
      it 'removes non numeric characters' do
        expect(sanitizer.sanitize('+1(234) 233-0987')).to eq('12342330987')
      end

      it 'adds a 1 country code if the number has a length of 10' do
        expect(sanitizer.sanitize('(24) 233-0987')).to eq('242330987')
        expect(sanitizer.sanitize('(234) 233-0987')).to eq('12342330987')
        expect(sanitizer.sanitize('11(234) 233-0987')).to eq('112342330987')
      end
    end
  end
end
