# frozen_string_literal: true

require 'models/dictionary'

RSpec.describe 'Models::Dictionary' do
  let(:dictionary) { Models::Dictionary.new }

  describe '#new' do
    it 'is initialized correctly' do
      expect(dictionary.identifiables).to be_a(Hash)
      expect(dictionary.identifiables.empty?).to be(true)
    end
  end

  describe '#process_row' do
    let(:parsed_row) { ['email:john@home.com', 'phone:5551234567'] }

    context 'when identifiables is empty' do
      before { dictionary.process_row(parsed_row) }

      it 'adds identifiables to identifiables hash' do
        expect(dictionary.identifiables.count).to be(2)
        expect(dictionary.identifiables.keys).to contain_exactly(*parsed_row)
      end

      it 'creates one identifier for the set of identifiables' do
        identifiers = dictionary.identifiables.values.map(&:identifier)
        expect(identifiers.map(&:uuid).uniq.count).to be(1)
      end
    end

    context 'when identifiables has values' do
      before { dictionary.process_row(parsed_row) }

      context 'when adding identifiables with overlap' do
        let(:parsed_row_with_overlap) { ['email:jill@home.com', 'phone:5551234567'] }

        before { dictionary.process_row(parsed_row_with_overlap) }

        it 'adds unknown identifiables to identifiables hash' do
          expect(dictionary.identifiables.count).to be(3)
          expect(dictionary.identifiables.keys).to contain_exactly(*parsed_row, 'email:jill@home.com')
        end

        it 'reuses the existing identifier for the new identifiable' do
          identifiers = dictionary.identifiables.values.map(&:identifier)
          expect(identifiers.map(&:uuid).uniq.count).to eq(1)
        end
      end

      context 'when adding identifiables without overlap' do
        let(:parsed_row_without_overlap) { ['email:jack@home.com', 'phone:1232224321'] }

        before { dictionary.process_row(parsed_row_without_overlap) }

        it 'adds all identifiables to identifiables hash' do
          expect(dictionary.identifiables.count).to be(4)
          expect(dictionary.identifiables.keys).to contain_exactly(*parsed_row, *parsed_row_without_overlap)
        end

        it 'creates a new identifier for the second set of identifiables' do
          identifiers = dictionary.identifiables.values.map(&:identifier)
          expect(identifiers.map(&:uuid).uniq.count).to eq(2)
        end
      end

      context 'when adding identifiables without overlap that get bridged' do
        let(:parsed_row_without_overlap) { ['email:jack@home.com', 'phone:1232224321'] }
        let(:parsed_row_that_bridges) { ['email:john@home.com', 'phone:1232224321'] }

        before do
          dictionary.process_row(parsed_row) # ['email:john@home.com', 'phone:5551234567']
          dictionary.process_row(parsed_row_without_overlap) # ['email:jack@home.com', 'phone:1232224321']
          dictionary.process_row(parsed_row_that_bridges) # ['email:john@home.com', 'phone:1232224321']
        end

        it 'adds all identifiables to identifiables hash' do
          expect(dictionary.identifiables.count).to be(4)
          expect(dictionary.identifiables.keys).to contain_exactly(*parsed_row, *parsed_row_without_overlap)
        end

        it 'bridges all of the identifiables under one UUID' do
          identifiers = dictionary.identifiables.values.map(&:identifier)
          expect(identifiers.map(&:uuid).uniq.count).to eq(1)
        end
      end
    end
  end

  describe '#uuid_lookup' do
    let(:parsed_row) { ['email:john@home.com', 'phone:5551234567'] }
    let(:parsed_row_with_overlap) { ['email:jill@home.com', 'phone:5551234567'] }
    let(:parsed_row_without_overlap) { ['email:jack@home.com', 'phone:1232224321'] }

    let(:known_uuids) { dictionary.identifiables.values.map { |identifiable| identifiable.identifier.uuid } }

    before do
      dictionary.process_row(parsed_row)
      dictionary.process_row(parsed_row_with_overlap)
      dictionary.process_row(parsed_row_without_overlap)
    end

    context 'when identifiable_value is nil' do
      let(:identifiable_value) { nil }

      it 'returns a UUID that is not in our dictionary' do
        uuid = dictionary.uuid_lookup(identifiable_value)
        expect(known_uuids.include?(uuid)).to eq(false)
      end
    end

    context 'when identifiable_value is any number of blank spaces' do
      let(:identifiable_value) { '   ' }

      it 'returns a UUID that is not in our dictionary' do
        uuid = dictionary.uuid_lookup(identifiable_value)
        expect(known_uuids.include?(uuid)).to eq(false)
      end
    end

    context 'when identifiable_value has a value' do
      let(:identifiable_value_1) { 'email:john@home.com' }
      let(:identifiable_value_2) { 'email:jill@home.com' }
      let(:identifiable_value_3) { 'email:jack@home.com' }

      it 'returns the correct uuid from the dictionary' do
        identifiable_1 = dictionary.identifiables[identifiable_value_1]
        identifiable_1_uuid = identifiable_1.identifier.uuid
        expect(dictionary.uuid_lookup(identifiable_value_1)).to eq(identifiable_1_uuid)

        identifiable_2 = dictionary.identifiables[identifiable_value_2]
        identifiable_2_uuid = identifiable_2.identifier.uuid
        expect(dictionary.uuid_lookup(identifiable_value_2)).to eq(identifiable_2_uuid)

        expect(dictionary.uuid_lookup(identifiable_value_1)).to eq(dictionary.uuid_lookup(identifiable_value_2)) # Have same UUID

        identifiable_3 = dictionary.identifiables[identifiable_value_3]
        identifiable_3_uuid = identifiable_3.identifier.uuid
        expect(dictionary.uuid_lookup(identifiable_value_3)).to eq(identifiable_3_uuid)

        expect(dictionary.uuid_lookup(identifiable_value_1)).not_to eq(dictionary.uuid_lookup(identifiable_value_3)) # Have different UUIDs
      end
    end
  end
end
