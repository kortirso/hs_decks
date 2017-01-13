RSpec.describe User, type: :model do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_presence_of :role }
    it { should validate_presence_of :username }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should have_many :decks }
    it { should have_many :checks }
    it { should validate_inclusion_of(:role).in_array(%w(user deck_master)) }
    it { should validate_uniqueness_of :username }
    it { should validate_length_of :username }

    it 'should be valid' do
        user = create :user

        expect(user).to be_valid
    end

    it 'should be valid with username, email and password' do
        user = User.new(username: 'tester', email: 'example@gmail.com', password: 'password')

        expect(user).to be_valid
    end

    it 'should be invalid without username' do
        user = User.new(username: nil)
        user.valid?

        expect(user.errors[:username]).to include("can't be blank")
    end

    it 'should be invalid without email' do
        user = User.new(email: nil)
        user.valid?

        expect(user.errors[:email]).to include("can't be blank")
    end

    it 'should be invalid without password' do
        user = User.new(password: nil)
        user.valid?

        expect(user.errors[:password]).to include("can't be blank")
    end

    it 'should be invalid with a duplicate username' do
        User.create(username: 'tester1', email: 'example1@gmail.com', password: 'password')
        user = User.new(username: 'tester1', email: 'example2@gmail.com', password: 'password')
        user.valid?

        expect(user.errors[:username]).to include('has already been taken')
    end

    it 'should be invalid with a duplicate email' do
        User.create(username: 'tester1', email: 'example@gmail.com', password: 'password')
        user = User.new(username: 'tester2', email: 'example@gmail.com', password: 'password')
        user.valid?
        
        expect(user.errors[:email]).to include('has already been taken')
    end

    describe 'Methods' do
        context '.deck_master?' do
            let!(:user_1) { create :user }
            let!(:user_2) { create :user, :deck_master }

            it 'returns false if user is not deck_master' do
                expect(user_1.deck_master?).to eq false
            end

            it 'returns true if user is deck_master' do
                expect(user_2.deck_master?).to eq true
            end
        end
    end
end
