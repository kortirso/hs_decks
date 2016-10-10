RSpec.describe Line, type: :model do
    it { should belong_to :deck }
    it { should belong_to :card }
    it { should validate_presence_of :deck_id }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :max_amount }
    it { should validate_presence_of :priority }

    it 'should be valid' do
        line = create :line

        expect(line).to be_valid
    end
end
