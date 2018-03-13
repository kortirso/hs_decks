RSpec.describe About, type: :model do
  it { should have_many(:fixes).dependent(:destroy) }
  it { should validate_presence_of :version }
  it { should validate_presence_of :name }

  it 'should be valid' do
    about = create :about

    expect(about).to be_valid
  end

  describe 'methods' do
    it_behaves_like 'Localizeable'

    def nameable_object
      create :about
    end
  end
end
