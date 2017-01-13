RSpec.describe Check, type: :model do
    it { should belong_to :user }
    it { should belong_to :deck }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :deck_id }
    it { should validate_presence_of :success }

    it 'should be valid' do
        check = create :check

        expect(check).to be_valid
    end
end
