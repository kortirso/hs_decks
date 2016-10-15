RSpec.describe Style, type: :model do
    it { should have_many :decks }
    it { should validate_presence_of :name_en }
    it { should validate_presence_of :name_ru }
    it { should validate_uniqueness_of :name_en }
    it { should validate_uniqueness_of :name_ru }

    it 'should be valid' do
        style = create :style

        expect(style).to be_valid
    end
end
