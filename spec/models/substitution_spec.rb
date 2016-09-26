RSpec.describe Substitution, type: :model do
    it { should belong_to :check }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should validate_presence_of :check_id }

    it 'should be valid' do
        substitution = create :substitution

        expect(substitution).to be_valid
    end
end
