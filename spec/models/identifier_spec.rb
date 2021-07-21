# frozen_string_literal: true

require 'models/indentifier'

RSpec.describe 'Models::Identifier' do
  let(:identifer_1) { Models::Identifier.new }

  describe '#new' do
    it 'is initialized correctly' do
      expect(identifer_1.identifiables).to be_a(Hash)
      expect(identifer_1.identifiables.empty?).to be(true)

      uuid_regex = /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i
      expect(uuid_regex =~ identifer_1.uuid).to be(0)
    end
  end

  describe '#add_identifiables' do
    let(:identifiable_1) { Models::Identifiable.new(identifer_1, 'email:john@home.com') }
    let(:identifiable_2) { Models::Identifiable.new(identifer_1, 'phone:5551234567') }
    let(:identifiables) { [identifiable_1, identifiable_2] }

    it 'creates identifiables and adds them to the identifiables hash' do
      identifer_1.add_identifiables(identifiables)

      expect(identifer_1.identifiables.count).to be(2)
      expect(identifer_1.identifiables.keys).to contain_exactly(*identifiables.map(&:value))
    end
  end

  describe '#merge' do
    let(:identifiable_1) { Models::Identifiable.new(identifer_2, 'email:john@home.com') }
    let(:identifiable_2) { Models::Identifiable.new(identifer_2, 'phone:5551234567') }
    let(:identifiables_1) { [identifiable_1, identifiable_2] }

    let(:identifiable_3) { Models::Identifiable.new(identifer_3, 'email:jill@home.com') }
    let(:identifiable_4) { Models::Identifiable.new(identifer_3, 'phone:2221234522') }
    let(:identifiables_2) { [identifiable_3, identifiable_4] }

    let(:identifer_2) { Models::Identifier.new }
    let(:identifer_3) { Models::Identifier.new }
    let(:identifers) { [identifer_2, identifer_3] }

    before do
      identifer_2.add_identifiables(identifiables_1)
      identifer_3.add_identifiables(identifiables_2)
    end

    it 'adds all identifiables to identifer and updates their link to the new identifer' do
      identifer_1.merge(identifers)

      expect(identifer_1.identifiables.count).to be(4)
      expect(identifer_1.identifiables.values).to contain_exactly(identifiable_1, identifiable_2, identifiable_3, identifiable_4)
      expect(identifer_1.identifiables.values.map(&:identifier).map(&:uuid).uniq).to eq([identifer_1.uuid])
    end
  end
end
