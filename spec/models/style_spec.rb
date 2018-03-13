RSpec.describe Style, type: :model do
  it { should have_many :decks }
  it { should validate_presence_of :name }

  it 'should be valid' do
    style = create :style

    expect(style).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :style
    end
  end
end
