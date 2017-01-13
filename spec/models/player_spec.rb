RSpec.describe Player, type: :model do
    it { should belong_to :multi_class }
    it { should have_many :cards }
    it { should have_many :decks }
    it { should validate_presence_of :name_en }
    it { should validate_presence_of :name_ru }

    it 'should be valid' do
        player = create :player

        expect(player).to be_valid
    end

    context 'Methods' do
        let!(:player) { create :player }

        context '.names' do
            it 'returns list of english player names if arg is en' do
                expect(Player.names('en')).to eq [player.name_en]
            end

            it 'returns list of russian player names if arg is ru' do
                expect(Player.names('ru')).to eq [player.name_ru]
            end
        end
        
        context '.return_en' do
            it 'returns english name if arg is en' do
                expect(Player.return_en(player.name_en)).to eq player.name_en
            end

            it 'returns english name if arg is ru' do
                expect(Player.return_en(player.name_ru)).to eq player.name_en
            end
        end

        context '.return_by_name' do
            it 'returns player by english name' do
                expect(Player.return_by_name(player.name_en)).to eq player
            end

            it 'returns player by russian name' do
                expect(Player.return_by_name(player.name_ru)).to eq player
            end

            it 'returns nil if player does not exist' do
                expect(Player.return_by_name('')).to eq nil
            end
        end

        context '.locale_name' do
            it 'returns english name if arg is en' do
                expect(player.locale_name('en')).to eq player.name_en
            end

            it 'returns russian name if arg is ru' do
                expect(player.locale_name('ru')).to eq player.name_ru
            end
        end
    end
end
