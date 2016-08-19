RSpec.describe Substitution, type: :model do
    it { should belong_to :check }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should validate_presence_of :check_id }

    it 'should be valid' do
        substitution = create :substitution

        expect(substitution).to be_valid
    end

    context 'Methods' do
        context '.find_exchange' do
            context 'if card has changes it should returns card (with highest priority) id and amount' do
                let!(:card) { create :card, cost: 4 }
                let!(:card_for_exchange_1) { create :card, cost: 2, playerClass: 'Priest' }
                let!(:card_for_exchange_2) { create :card, cost: 2, playerClass: nil }
                let!(:shift_1) { Shift.create card: card, change: card_for_exchange_1, priority: 10 }
                let!(:shift_2) { Shift.create card: card, change: card_for_exchange_2, priority: 9 }

                it 'for Priest' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [], [])).to eq [card_for_exchange_1.id, 1]
                end

                it 'for Priest but with 1 exchanged card in deck' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [card_for_exchange_1.id], [])).to eq [card_for_exchange_2.id, 1]
                end

                it 'for Priest but with 1 exchanged card in substitutions' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [], [card_for_exchange_1.id])).to eq [card_for_exchange_2.id, 1]
                end

                it 'for Shaman' do
                    expect(Substitution.find_exchange(card.id, 1, 'Shaman', [], [])).to eq [card_for_exchange_2.id, 1]
                end
            end

            context 'if card does not have changes should returns id of random card and amount' do
                let!(:card) { create :card, cost: 4, playerClass: nil }
                let!(:card_for_4_mana_1) { create :card, cost: 4, rarity: 'Free', playerClass: nil }
                let!(:card_for_4_mana_2) { create :card, cost: 4, rarity: 'Free', playerClass: nil }

                it 'from all cards' do
                    exchange = Substitution.find_exchange(card.id, 1, 'Priest', [], [])

                    expect(exchange == [card_for_4_mana_1.id, 1] || exchange == [card_for_4_mana_2.id, 1]).to eq true
                end

                it 'but with 1 exchanged card in deck' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [card_for_4_mana_1.id], [])).to eq [card_for_4_mana_2.id, 1]
                end

                it 'but with 1 exchanged card in substitutions' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [], [card_for_4_mana_2.id])).to eq [card_for_4_mana_1.id, 1]
                end

                it 'but if no substitutions then returns self' do
                    expect(Substitution.find_exchange(card.id, 1, 'Priest', [card_for_4_mana_1.id], [card_for_4_mana_2.id])).to eq [card.id, 1]
                end
            end
        end
    end
end
