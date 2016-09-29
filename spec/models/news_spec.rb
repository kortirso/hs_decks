RSpec.describe News, type: :model do
    it { should validate_presence_of :url_label }
    it { should validate_presence_of :label }
    it { should validate_presence_of :caption }
    it { should validate_presence_of :image }

    it 'should be valid' do
        news = create :news

        expect(news).to be_valid
    end
end
