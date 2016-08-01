RSpec.describe Position, type: :model do
    it { should belong_to :deck }
    it { should belong_to :card }
    it { should validate_presence_of :deck_id }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :amount }
    it { should validate_inclusion_of(:amount).in_range(1..2) }

    it 'should be valid' do
        position = create :position

        expect(position).to be_valid
    end
end
