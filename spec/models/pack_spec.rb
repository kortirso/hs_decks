RSpec.describe Pack, type: :model do
    it { should belong_to :user }
    it { should belong_to :card }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :card_id }
    it { should validate_presence_of :amount }
    it { should validate_inclusion_of(:amount).in_range(1..2) }

    it 'should be valid' do
        pack = create :pack

        expect(pack).to be_valid
    end

    context 'methods' do
        context '.collect_ids' do

        end

        context '.build' do

        end
    end
end
