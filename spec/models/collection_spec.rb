RSpec.describe Collection, type: :model do
    it { should have_many :cards }
    it { should validate_presence_of :name }
    it { should validate_presence_of :formats }
    it { should validate_inclusion_of(:name).in_array(%w(Basic Classic Promo Reward Naxxramas Goblins\ vs\ Gnomes Blackrock\ Mountain The\ Grand\ Tournament The\ League\ of\ Explorers Whispers\ of\ the\ Old\ Gods)) }
    it { should validate_inclusion_of(:formats).in_array(%w(standard free)) }

    it 'should be valid' do
        collection = create :collection

        expect(collection).to be_valid
    end

    context 'Methods' do
        context '.free_format?' do
            
        end
    end
end
