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
        context '.wild_format?' do
            let!(:collection_1) { create :collection }
            let!(:collection_2) { create :collection, :wild_collection }

            it 'should return false if collection is not wild' do
                expect(collection_1.wild_format?).to eq false
            end

            it 'should return true if collection is wild' do
                expect(collection_2.wild_format?).to eq true
            end
        end
    end
end
