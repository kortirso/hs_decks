RSpec.describe Card, type: :model do
    it { should belong_to :collection }
    it { should belong_to :player }
    it { should belong_to :multi_class }
    it { should validate_presence_of :cardId }
    it { should validate_presence_of :name_en }
    it { should validate_presence_of :type }
    it { should validate_presence_of :rarity }
    it { should validate_presence_of :collection_id }
    it { should validate_presence_of :usable }
    it { should validate_inclusion_of(:type).in_array(%w(Hero Spell Minion Weapon)) }
    it { should validate_inclusion_of(:playerClass).in_array(%w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue Neutral)) }
    it { should validate_inclusion_of(:rarity).in_array(%w(Free Common Rare Epic Legendary)) }
    it { should have_many :positions }
    it { should have_many :shifts }
    it { should have_many(:exchanges).through(:shifts) }
    it { should have_many(:decks).through(:positions) }
    it { should have_many(:users).through(:positions) }
    it { should have_many(:checks).through(:positions) }
    it { should have_many :exchanges }
    it { should have_many :lines }
    it { should validate_presence_of :formats }
    it { should validate_inclusion_of(:formats).in_array(%w(standard wild)) }

    it 'should be valid' do
        card = create :card

        expect(card).to be_valid
    end

    context 'Methods' do
        context '.with_cost' do
            let!(:card_1_mana) { create :card, cost: 1 }
            let!(:card_7_mana) { create :card, cost: 7 }
            let!(:card_10_mana) { create :card, cost: 10 }

            it 'should return cards with spesific mana if param is lower than 7' do
                expect(Card.with_cost(1)).to eq [card_1_mana]
            end

            it 'should return cards with 7+ mana if param is 7 or more' do
                expect(Card.with_cost(8)).to eq [card_7_mana, card_10_mana]
            end
        end

        context '.wild_format?' do
            let!(:card_1) { create :card }
            let!(:card_2) { create :card, :wild_card }

            it 'should return false if card is not wild' do
                expect(card_1.wild_format?).to eq false
            end

            it 'should return true if card is wild' do
                expect(card_2.wild_format?).to eq true
            end
        end

        context '.is_crafted?' do
            let!(:card_1) { create :card }
            let!(:card_2) { create :card, craft: false }

            it 'should return true if it is crafted' do
                expect(card_1.is_crafted?).to eq true
            end

            it 'should return false if it is not crafted' do
                expect(card_2.is_crafted?).to eq false
            end
        end

        context '.check_cards_format' do
            let!(:collection) { create :collection }
            let!(:cards) { create_list(:card, 3, collection: collection) }
            let!(:another_card) { create :card }
            before do
                collection.update(formats: 'wild')
                Card.check_cards_format
            end

            it 'should change cards format if collection changed format' do
                cards.each do |card|
                    card.reload

                    expect(card.formats).to eq 'wild'
                end
            end

            it 'and should not change format of card from another collection' do
                another_card.reload

                expect(another_card.formats).to eq 'standard'
            end
        end

        context '.check_cards_crafted' do
            let!(:collection) { create :collection }
            let!(:cards) { create_list(:card, 3, collection: collection) }
            let!(:another_card) { create :card }
            before do
                collection.update(adventure: true)
                Card.check_cards_crafted
            end

            it 'should change cards crafting if collection is adventure' do
                cards.each do |card|
                    card.reload

                    expect(card.is_crafted?).to eq false
                end
            end

            it 'and should not change card crafting from another collection' do
                another_card.reload

                expect(another_card.is_crafted?).to eq true
            end
        end
    end
end
