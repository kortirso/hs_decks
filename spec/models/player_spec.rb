RSpec.describe Player, type: :model do
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

        context '.locale_name' do
            it 'should return name_en if en locale' do
                expect(player.locale_name('en')).to eq player.name_en
            end

            it 'should return name_ru if ru locale' do
                expect(player.locale_name('ru')).to eq player.name_ru
            end
        end

        context '.names' do
            it 'should return list of name_en if en locale' do
                expect(Player.names('en')).to eq [player.name_en]
            end

            it 'should return list of name_ru if ru locale' do
                expect(Player.names('ru')).to eq [player.name_ru]
            end
        end
        
        context '.return_en' do
            it 'should return name_en if en name' do
                expect(Player.return_en('Shaman')).to eq player.name_en
            end

            it 'should return name_en if ru name' do
                expect(Player.return_en('Шаман')).to eq player.name_en
            end
        end
    end
end
