# frozen_string_literal: false

# require 'sanitizers/blank_sanitizer'

RSpec.describe 'Sanitizers::BlankSanitizer' do
  let(:sanitizer) { Sanitizers::BlankSanitizer }

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
      it 'returns the string as it is' do
        expect(sanitizer.sanitize('Some String - 2122 +!@#%^&*()><.,')).to eq('Some String - 2122 +!@#%^&*()><.,')
      end
    end
  end
end
