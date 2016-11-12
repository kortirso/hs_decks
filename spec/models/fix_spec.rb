RSpec.describe Fix, type: :model do
    it { should belong_to :about }
    it { should validate_presence_of :about_id }
    it { should validate_presence_of :body_en }
    it { should validate_presence_of :body_ru }

    it 'should be valid' do
        fix = create :fix

        expect(fix).to be_valid
    end
end
