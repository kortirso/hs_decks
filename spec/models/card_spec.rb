RSpec.describe Card, type: :model do
    it { should belong_to :collection }
    it { should validate_presence_of :cardId }
    it { should validate_presence_of :name }
    it { should validate_presence_of :type }
    it { should validate_presence_of :rarity }
    it { should validate_presence_of :collection_id }
    it { should validate_inclusion_of(:type).in_array(%w(Hero Spell Minion Weapon)) }
    it { should validate_inclusion_of(:playerClass).in_array(%w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue)).allow_nil }
    it { should validate_inclusion_of(:rarity).in_array(%w(Free Common Rare Epic Legendary)) }
    it { should have_many :packs }
    it { should have_many(:users).through(:packs) }
    it { should have_many :positions }
    it { should have_many(:decks).through(:positions) }

    it 'should be valid' do
        card = create :card

        expect(card).to be_valid
    end
end
