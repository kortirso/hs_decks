RSpec.describe Exchange, type: :model do
    it { should belong_to :position }
    it { should belong_to :card }
    it { should validate_presence_of :position_id }
    it { should validate_presence_of :card_id }

    it 'should be valid' do
        exchange = create :exchange

        expect(exchange).to be_valid
    end
end
