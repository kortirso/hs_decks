RSpec.describe Position, type: :model do
    it { should belong_to :positionable }
    it { should belong_to :card }
    it { should validate_presence_of :positionable_id }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :amount }
    it { should validate_inclusion_of(:amount).in_range(0..2) }

    it 'should be valid for user' do
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
        context '.collect_ids' do
            let!(:user) { create :user }
            let!(:positions) { create_list(:position_for_user, 2, positionable: user) }

            it 'should return cards id and amount in users collection' do
                expect(user.positions.collect_ids).to eq [[positions.first.card_id, positions.first.amount], [positions.last.card_id, positions.last.amount]]
            end
        end
    end
end
