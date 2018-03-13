RSpec.describe Mulligan, type: :model do
  it { should belong_to :player }
  it { should belong_to :deck }
  it { should have_many :positions }
  it { should have_many(:cards).through(:positions) }
  it { should validate_presence_of :player_id }
  it { should validate_presence_of :deck_id }

  it 'should be valid' do
    mulligan = create :mulligan

    expect(mulligan).to be_valid
  end
end
