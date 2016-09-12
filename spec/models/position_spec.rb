RSpec.describe Position, type: :model do
    it { should belong_to :positionable }
    it { should belong_to :card }
    it { should validate_presence_of :positionable_id }
    it { should validate_presence_of :positionable_type }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :amount }
    it { should validate_inclusion_of(:amount).in_range(0..2) }

    it 'should be valid for_user' do
        position = create :position_for_user

        expect(position).to be_valid
    end

    it 'should be valid for_deck' do
        position = create :position_for_deck

        expect(position).to be_valid
    end

    it 'should be valid for_check' do
        position = create :position_for_check

        expect(position).to be_valid
    end

    context 'methods' do
        let!(:user) { create :user }

        context '.collect_ids' do
            let!(:positions) { create_list(:position_for_user, 2, positionable: user) }

            it 'should return cards id and amount in users collection' do
                expect(user.positions.collect_ids).to eq [[positions.first.card_id, positions.first.amount], [positions.last.card_id, positions.last.amount]]
            end
        end

        context '.collect_ids_with_rarity' do
            let!(:positions) { create_list(:position_for_user, 2, positionable: user) }

            it 'should return cards id and amount in users collection' do
                expect(user.positions.collect_ids_with_rarity).to eq [[positions.first.card_id, positions.first.amount, positions.first.card.rarity, positions.first.card.is_crafted?], [positions.last.card_id, positions.last.amount, positions.last.card.rarity, positions.first.card.is_crafted?]]
            end
        end

        context '.with_sorted_cards' do
            let!(:card_1) { create :card, cost: 8, name_en: 'A' }
            let!(:card_2) { create :card, cost: 4, name_en: 'A' }
            let!(:card_3) { create :card, cost: 4, name_en: 'B' }
            let!(:position_1) { create :position_for_user, positionable: user, card: card_1 }
            let!(:position_2) { create :position_for_user, positionable: user, card: card_2 }
            let!(:position_3) { create :position_for_user, positionable: user, card: card_3 }

            it 'should returns array of cards' do
                expect(user.positions.with_sorted_cards.kind_of? Array).to eq true
                expect(user.positions.with_sorted_cards.size).to eq 3
            end

            it 'and at first place is card_2' do
                expect(user.positions.with_sorted_cards[0]).to eq card_2
            end

            it 'and at second place is card_3' do
                expect(user.positions.with_sorted_cards[1]).to eq card_3
            end

            it 'and at third place is card_1' do
                expect(user.positions.with_sorted_cards[2]).to eq card_1
            end
        end
    end
end
