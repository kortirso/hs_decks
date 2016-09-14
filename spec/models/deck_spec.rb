RSpec.describe Deck, type: :model do
    it { should belong_to :user }
    it { should belong_to :player }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should have_many :checks }
    it { should validate_presence_of :name }
    it { should validate_presence_of :playerClass }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :formats }
    it { should validate_presence_of :player_id }
    it { should validate_presence_of :power }
    it { should validate_inclusion_of(:playerClass).in_array(%w(Priest Warrior Warlock Mage Druid Hunter Shaman Paladin Rogue)) }
    it { should validate_inclusion_of(:formats).in_array(%w(standard wild)) }
    it { should validate_inclusion_of(:power).in_range(1..10) }

    it 'should be valid' do
        deck = create :deck

        expect(deck).to be_valid
    end

    context 'methods' do
        context '.build' do

        end

        context '.build_positions' do

        end

        context '.refresh' do

        end

        context '.update_positions' do

        end

        context '.check_deck_format' do

        end

        context '.good_params?' do
            context '.check_deck_params' do

            end

            context '.check_30_cards' do

            end

            context '.check_dublicates' do

            end

            context '.check_cards_class' do

            end
        end
    end
end
