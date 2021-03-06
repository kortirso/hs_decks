RSpec.describe Race, type: :model do
  it { should have_many :cards }
  it { should have_many :decks }
  it { should validate_presence_of :name }

  it 'should be valid' do
    race = create :race

    expect(race).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :race
    end
  end
end
