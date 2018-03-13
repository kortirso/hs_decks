RSpec.describe Deck, type: :model do
  it { should belong_to :user }
  it { should belong_to :player }
  it { should belong_to :style }
  it { should have_many :positions }
  it { should have_many(:cards).through(:positions) }
  it { should have_many(:checks).dependent(:destroy) }
  it { should have_many(:lines).dependent(:destroy) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :playerClass }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :formats }
  it { should validate_presence_of :player_id }
  it { should validate_presence_of :power }
  it { should validate_inclusion_of(:playerClass).in_array(%w[Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue]) }
  it { should validate_inclusion_of(:formats).in_array(%w[standard wild]) }
  it { should validate_inclusion_of(:power).in_range(1..10) }

  it 'should be valid' do
    deck = create :deck

    expect(deck).to be_valid
  end

  describe 'Methods' do
    context '.check_deck_format' do
      let!(:card_1) { create :card }
      let!(:card_2) { create :card, :wild_card }
      let!(:standard_position) { create :position_for_deck, card: card_1 }
      let!(:wild_position) { create :position_for_deck, card: card_2 }

      it 'does not update deck format if card in deck is standard' do
        deck = standard_position.positionable

        expect { deck.check_deck_format }.to_not change(deck, :formats).from('standard')
      end

      it 'updates deck format if card in deck is wild' do
        deck = wild_position.positionable

        expect { deck.check_deck_format }.to change(deck, :formats).from('standard').to('wild')
      end
    end

    context '.reno_type?' do
      let!(:deck_1) { create :deck }
      let!(:deck_2) { create :deck, reno_type: true }

      it 'returns false if deck is not reno_type' do
        expect(deck_1.reno_type?).to eq false
      end

      it 'returns true if deck is reno_type' do
        expect(deck_2.reno_type?).to eq true
      end
    end
  end
end
