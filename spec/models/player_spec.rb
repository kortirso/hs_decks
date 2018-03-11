RSpec.describe Player, type: :model do
  it { should belong_to :multi_class }
  it { should have_many(:cards).dependent(:destroy) }
  it { should have_many(:decks).dependent(:destroy) }
  it { should validate_presence_of :name }

  it 'should be valid' do
    player = create :player

    expect(player).to be_valid
  end

  context 'Methods' do
    let!(:player) { create :player }

    context '.names_list' do
      it 'returns list of english player names if arg is en' do
        expect(Player.names_list('en')).to eq [player.name['en']]
      end

      it 'returns list of russian player names if arg is ru' do
        expect(Player.names_list('ru')).to eq [player.name['ru']]
      end
    end

    context '.find_by_locale_name' do
      it 'returns object if arg for en' do
        expect(Player.find_by_locale_name('en', player.name['en'])).to eq player
      end

      it 'returns object if arg for ru' do
        expect(Player.find_by_locale_name('ru', player.name['ru'])).to eq player
      end

      it 'returns nil for incorrect data' do
        expect(Player.find_by_locale_name('ru', player.name['en'])).to eq nil
      end
    end

    context '.find_by_name' do
      it 'returns object if arg is en' do
        expect(Player.find_by_name(player.name['en'])).to eq player
      end

      it 'returns object if arg is ru' do
        expect(Player.find_by_name(player.name['ru'])).to eq player
      end

      it 'returns nil for incorrect data' do
        expect(Player.find_by_name('123')).to eq nil
      end
    end
  end
end
