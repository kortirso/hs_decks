RSpec.describe Shift, type: :model do
    it { should belong_to :card }
    it { should belong_to :change }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :change_id }
    it { should validate_presence_of :priority }

    it 'should be valid' do
        shift = create :shift

        expect(shift).to be_valid
    end
end
