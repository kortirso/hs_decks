RSpec.describe Pack, type: :model do
    it { should belong_to :user }
    it { should belong_to :card }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :card_id }
    it { should validate_inclusion_of(:amount).in_range(1..2) }
end
