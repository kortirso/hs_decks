RSpec.describe User, type: :model do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role }
    it { should have_many :packs }
    it { should have_many(:cards).through(:packs) }
    it { should have_many :decks }
    it { should have_many :checks }
    it { should validate_inclusion_of(:role).in_array(%w(user deck_master)) }

    describe 'User' do
        let(:user) { create :user }

        it 'should be valid' do
            expect(user).to be_valid
        end

        it 'should be invalid when sign up with existed email' do
            expect { create :user, email: user.email }.to raise_error(ActiveRecord::RecordInvalid)
        end
    end

    context 'methods' do
        context '.deck_master?' do

        end
    end
end
