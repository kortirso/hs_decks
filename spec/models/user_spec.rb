RSpec.describe User, type: :model do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
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
            let!(:user_1) { create :user }
            let!(:user_2) { create :user, :deck_master }

            it 'should return false if user is not deck_master' do
                expect(user_1.deck_master?).to eq false
            end

            it 'should return true if user is deck_master' do
                expect(user_2.deck_master?).to eq true
            end
        end

        context '.build_collection' do

        end

        context '.update_collection' do

        end
        
        context '.adding_to_collection' do

        end
    end
end
