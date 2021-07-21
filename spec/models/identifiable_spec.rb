# frozen_string_literal: true

require 'models/identifiable'

RSpec.describe 'Models::Identifiable' do
  let(:identifiable) { Models::Identifiable.new(identifer_1, value) }
  let(:identifer_1) { Models::Identifier.new }
  let(:value) { 'email:jack@home.com' }

  describe '#new' do
    it 'is initialized correctly' do
      expect(identifiable.value).to eq(value)
      expect(identifiable.identifier).to be(identifer_1)
    end
  end

  describe '#update_identifier' do
    let(:identifer_2) { Models::Identifier.new }

    it 'creates identifiables and adds them to the identifiables hash' do
      expect(identifiable.identifier).to be(identifer_1)
      identifiable.update_identifier(identifer_2)
      expect(identifiable.identifier).to be(identifer_2)
    end
  end
end
