RSpec.describe Collection, type: :model do
  it { should have_many(:cards).dependent(:destroy) }
  it { should validate_presence_of :name }
  it { should validate_presence_of :formats }
  it { should validate_inclusion_of(:formats).in_array(%w[standard wild]) }

  it 'should be valid' do
    collection = create :collection

    expect(collection).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :collection
    end

    context '.wild?' do
      let!(:collection) { create :collection }
      let!(:collection_2) { create :collection, :wild_collection }

      it 'returns false if collection is not wild' do
        expect(collection.wild?).to eq false
      end

      it 'returns true if collection is wild' do
        expect(collection_2.wild?).to eq true
      end
    end

    context '.adventure?' do
      let!(:collection) { create :collection }
      let!(:collection_2) { create :collection, adventure: true }

      it 'returns false if it is not adventure' do
        expect(collection.adventure?).to eq false
      end

      it 'returns true if it is adventure' do
        expect(collection_2.adventure?).to eq true
      end
    end
  end
end
