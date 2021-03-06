RSpec.describe Card, type: :model do
  it { should belong_to :collection }
  it { should belong_to :player }
  it { should belong_to :multi_class }
  it { should validate_presence_of :cardId }
  it { should validate_presence_of :name }
  it { should validate_presence_of :type }
  it { should validate_presence_of :rarity }
  it { should validate_presence_of :collection_id }
  it { should validate_presence_of :usable }
  it { should validate_presence_of :formats }
  it { should validate_inclusion_of(:formats).in_array(%w[standard wild]) }
  it { should validate_inclusion_of(:type).in_array(%w[Hero Spell Minion Weapon]) }
  it { should validate_inclusion_of(:playerClass).in_array(%w[Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue Neutral]) }
  it { should validate_inclusion_of(:rarity).in_array(%w[Free Common Rare Epic Legendary]) }
  it { should have_many(:positions).dependent(:destroy) }
  it { should have_many(:shifts).dependent(:destroy) }
  it { should have_many(:exchanges).through(:shifts) }
  it { should have_many(:decks).through(:positions) }
  it { should have_many(:users).through(:positions) }
  it { should have_many(:checks).through(:positions) }
  it { should have_many(:mulligans).through(:positions) }
  it { should have_many(:exchanges).through(:shifts) }
  it { should have_many :lines }

  it 'should be valid' do
    card = create :card

    expect(card).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :card
    end

    context '.with_cost' do
      let!(:card_1_mana) { create :card, cost: 1 }
      let!(:card_7_mana) { create :card, cost: 7 }
      let!(:card_10_mana) { create :card, cost: 10 }

      it 'returns cards with spesific mana if param is lower than 7' do
        expect(Card.with_cost(1)).to eq [card_1_mana]
      end

      it 'returns cards with 7+ mana if param is 7 or more' do
        expect(Card.with_cost(8)).to eq [card_7_mana, card_10_mana]
      end
    end

    context '.wild?' do
      let!(:card_1) { create :card }
      let!(:card_2) { create :card, :wild_card }

      it 'returns false if card is not wild' do
        expect(card_1.wild?).to eq false
      end

      it 'returns true if card is wild' do
        expect(card_2.wild?).to eq true
      end
    end

    context '.craft?' do
      let!(:card_1) { create :card }
      let!(:card_2) { create :card, craft: false }

      it 'returns true if it is crafted' do
        expect(card_1.craft?).to eq true
      end

      it 'returns false if it is not crafted' do
        expect(card_2.craft?).to eq false
      end
    end

    context '.legendary?' do
      let!(:card_1) { create :card, rarity: 'Legendary' }
      let!(:card_2) { create :card }

      it 'should return true if it is legendary' do
        expect(card_1.legendary?).to eq true
      end

      it 'should return false if it is not legendary' do
        expect(card_2.legendary?).to eq false
      end
    end
  end
end
