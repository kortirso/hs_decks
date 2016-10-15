RSpec.describe Check, type: :model do
    it { should belong_to :user }
    it { should belong_to :deck }
    it { should have_many :positions }
    it { should have_many(:cards).through(:positions) }
    it { should validate_presence_of :user_id }
    it { should validate_presence_of :deck_id }
    it { should validate_presence_of :success }

    it 'should be valid' do
        check = create :check

        expect(check).to be_valid
    end

    context 'Methods' do
        let(:empty_params) { ActionController::Parameters.new({ success: '', dust: '', playerClass: '', formats: 'wild', something: '', power: '', style: '' }) }

        context '.build' do
            
        end

        context '.verify_deck' do

        end

        context '.limitations' do
            let!(:user) { create :user }
            let!(:deck) { create :deck, price: 5000 }
            let!(:position) { create :position_for_deck, positionable: deck }
            let!(:check) { create :check, user: user, deck: deck }
            let(:lines) { ["('#{position.card_id}', '#{check.id}', 'Check', '#{0}', '', '#{Time.current}', '#{Time.current}')"] }

            context 'without limits' do
                let(:success) { 10 }
                let(:dust) { 1000 }

                it 'returns updated success rate' do
                    expect { check.limitations(empty_params, success, dust, lines) }.to change(check, :success).from(0).to(10)
                end

                it 'and returns updated dust rate' do
                    expect { check.limitations(empty_params, success, dust, lines) }.to change(check, :dust).from(0).to(dust)
                end

                it 'and creates new position for check' do
                    expect { check.limitations(empty_params, success, dust, lines) }.to change(check.positions, :count).from(0).to(1)
                end

                it 'and returns self' do
                    expect(check.limitations(empty_params, success, dust, lines)).to eq check
                end
            end

            context 'with limits' do
                let(:params) { ActionController::Parameters.new({ success: '', dust: '1000', playerClass: '', formats: 'wild', something: '', power: '', style: '' }) }
                let(:success) { 10 }
                let(:dust) { 2500 }

                it 'destroy check' do
                    expect { check.limitations(params, success, dust, lines) }.to change(Check, :count).by(-1)
                end

                it 'and does not create new check positions' do
                    expect { check.limitations(params, success, dust, lines) }.to_not change(Position, :count)
                end

                it 'and returns nil' do
                    expect(check.limitations(params, success, dust, lines)).to eq nil
                end
            end
        end

        context '.getting_decks' do
            let!(:shaman_deck) { create :deck, playerClass: 'Shaman', formats: 'wild' }
            let!(:hunter_deck) { create :deck, playerClass: 'Hunter', formats: 'wild' }
            let!(:standard_mage_deck) { create :deck, playerClass: 'Mage', formats: 'standard' }

            it 'should returns all 3 decks if conditions are empty' do
                expect(Check.getting_decks(empty_params).size).to eq 3
            end

            it 'should returns shaman deck if conditions are with shamans limit' do
                params = ActionController::Parameters.new({ success: '', dust: '', playerClass: 'Shaman', formats: 'wild', something: '', power: '', style: '' })
                decks = Check.getting_decks(params)

                expect(decks.size).to eq 1
                expect(decks.first).to eq shaman_deck
            end

            it 'should returns standard deck if conditions are with standard format limit' do
                params = ActionController::Parameters.new({ success: '', dust: '', playerClass: '', formats: 'standard', something: '', power: '', style: '' })
                decks = Check.getting_decks(params)

                expect(decks.size).to eq 1
                expect(decks.first).to eq standard_mage_deck
            end
        end
    end
end
