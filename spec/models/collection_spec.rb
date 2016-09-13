RSpec.describe Collection, type: :model do
    it { should have_many :cards }
    it { should validate_presence_of :name_en }
    it { should validate_presence_of :name_ru }
    it { should validate_presence_of :formats }
    it { should validate_inclusion_of(:formats).in_array(%w(standard wild)) }

    it 'should be valid' do
        collection = create :collection

        expect(collection).to be_valid
    end

    context 'Methods' do
        let!(:collection) { create :collection }

        context '.locale_name' do
            it 'should return name_en if en locale' do
                expect(collection.locale_name('en')).to eq collection.name_en
            end

            it 'should return name_ru if ru locale' do
                expect(collection.locale_name('ru')).to eq collection.name_ru
            end
        end

        context '.wild_format?' do
            let!(:collection_2) { create :collection, :wild_collection }

            it 'should return false if collection is not wild' do
                expect(collection.wild_format?).to eq false
            end

            it 'should return true if collection is wild' do
                expect(collection_2.wild_format?).to eq true
            end
        end

        context '.is_adventure?' do
            let!(:collection_2) { create :collection, adventure: true }

            it 'should return false if it is not adventure' do
                expect(collection.is_adventure?).to eq false
            end

            it 'should return true if it is adventure' do
                expect(collection_2.is_adventure?).to eq true
            end
        end
    end
end
