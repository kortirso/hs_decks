RSpec.describe Deck, type: :model do
    it { should belong_to :user }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should validate_presence_of :name }
    it { should validate_presence_of :playerClass }
    it { should validate_presence_of :user_id }
    it { should validate_inclusion_of(:playerClass).in_array(%w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue)) }

    it 'should be valid' do
        deck = create :deck

        expect(deck).to be_valid
    end
end
