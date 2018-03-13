RSpec.describe Player, type: :model do
  it { should belong_to :multi_class }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:decks).dependent(:destroy) }
  it { should validate_presence_of :name }

  it 'should be valid' do
    player = create :player

    expect(player).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :player
    end
  end
end
