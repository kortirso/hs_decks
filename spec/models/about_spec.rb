RSpec.describe About, type: :model do
    it { should have_many(:fixes).dependent(:destroy) }
    it { should validate_presence_of :version }
    it { should validate_presence_of :label_en }
    it { should validate_presence_of :label_ru }

    it 'should be valid' do
        about = create :about

        expect(about).to be_valid
    end

    describe 'Methods' do
        context '.locale_label' do
            let!(:about) { create :about }

            it 'returns english label if arg is en' do
                expect(about.locale_label('en')).to eq about.label_en
            end

            it 'returns russian label if arg is ru' do
                expect(about.locale_label('ru')).to eq about.label_ru
            end
        end
    end
end
