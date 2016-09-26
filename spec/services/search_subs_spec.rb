describe SearchSubs do
    context '.find_exchange' do
        context 'if card has changes it should returns card (with highest priority) id and amount' do
            let!(:card) { create :card, cost: 4 }
            let!(:card_for_exchange_1) { create :card, cost: 2, playerClass: 'Priest' }
            let!(:card_for_exchange_2) { create :card, cost: 2, playerClass: nil }
            let!(:shift_1) { Shift.create card: card, change: card_for_exchange_1, priority: 10 }
            let!(:shift_2) { Shift.create card: card, change: card_for_exchange_2, priority: 9 }
            

            context 'for Priest' do
                let(:search_engine) { SearchSubs.new('Priest') }

                it 'without exchanged cards in deck' do
                    expect(search_engine.find_exchange(card.id, 1, [], [])).to eq [card_for_exchange_1.id, 1]
                end

                it 'with 1 exchanged card in deck' do
                    expect(search_engine.find_exchange(card.id, 1, [card_for_exchange_1.id], [])).to eq [card_for_exchange_2.id, 1]
                end

                it 'with 1 exchanged card in substitutions' do
                    expect(search_engine.find_exchange(card.id, 1, [], [card_for_exchange_1.id])).to eq [card_for_exchange_2.id, 1]
                end
            end

            context 'for Shaman' do
                let(:search_engine) { SearchSubs.new('Shaman') }

                it 'without exchanged cards in deck' do
                    expect(search_engine.find_exchange(card.id, 1, [], [])).to eq [card_for_exchange_2.id, 1]
                end
            end
        end

        context 'if card does not have changes should returns id of random card and amount' do
            let!(:card) { create :card, cost: 4, playerClass: nil }
            let!(:card_for_4_mana_1) { create :card, cost: 4, rarity: 'Free', playerClass: nil }
            let!(:card_for_4_mana_2) { create :card, cost: 4, rarity: 'Free', playerClass: nil }
            let(:search_engine) { SearchSubs.new('Priest') }

            it 'from all cards' do
                exchange = search_engine.find_exchange(card.id, 1, [], [])

                expect(exchange == [card_for_4_mana_1.id, 1] || exchange == [card_for_4_mana_2.id, 1]).to eq true
            end

            it 'but with 1 exchanged card in deck' do
                expect(search_engine.find_exchange(card.id, 1, [card_for_4_mana_1.id], [])).to eq [card_for_4_mana_2.id, 1]
            end

            it 'but with 1 exchanged card in substitutions' do
                expect(search_engine.find_exchange(card.id, 1, [], [card_for_4_mana_2.id])).to eq [card_for_4_mana_1.id, 1]
            end

            it 'but if no substitutions then returns self' do
                expect(search_engine.find_exchange(card.id, 1, [card_for_4_mana_1.id], [card_for_4_mana_2.id])).to eq [card.id, 1]
            end
        end
    end
end