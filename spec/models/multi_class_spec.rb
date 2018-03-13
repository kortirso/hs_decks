RSpec.describe MultiClass, type: :model do
  it { should have_many :cards }
  it { should have_many :players }
  it { should validate_presence_of :name }

  it 'should be valid' do
    multi_class = create :multi_class

    expect(multi_class).to be_valid
  end

  context 'Methods' do
    it_behaves_like 'Localizeable'
    it_behaves_like 'Nameable'

    def nameable_object
      create :multi_class
    end
  end
end
