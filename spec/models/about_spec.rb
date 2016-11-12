RSpec.describe About, type: :model do
    it { should have_many :fixes }
    it { should validate_presence_of :version }
    it { should validate_presence_of :label_en }
    it { should validate_presence_of :label_ru }

    it 'should be valid' do
        about = create :about

        expect(about).to be_valid
    end
end
