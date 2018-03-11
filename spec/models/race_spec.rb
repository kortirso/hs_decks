RSpec.describe Race, type: :model do
  it { should have_many :cards }
  it { should have_many :decks }
  it { should validate_presence_of :name }

  it 'should be valid' do
    race = create :race

    expect(race).to be_valid
  end

  context 'Methods' do
    let!(:race) { create :race }

    context '.locale_name' do
      it 'returns english name if arg is en' do
        expect(race.locale_name('en')).to eq race.name['en']
      end

      it 'returns russian name if arg is ru' do
        expect(race.locale_name('ru')).to eq race.name['ru']
      end
    end

    context '.find_by_locale_name' do
      it 'returns object if arg for en' do
        expect(Race.find_by_locale_name('en', race.name['en'])).to eq race
      end

      it 'returns object if arg for ru' do
        expect(Race.find_by_locale_name('ru', race.name['ru'])).to eq race
      end

      it 'returns nil for incorrect data' do
        expect(Race.find_by_locale_name('ru', race.name['en'])).to eq nil
      end
    end

    context '.find_by_name' do
      it 'returns object if arg is en' do
        expect(Race.find_by_name(race.name['en'])).to eq race
      end

      it 'returns object if arg is ru' do
        expect(Race.find_by_name(race.name['ru'])).to eq race
      end

      it 'returns nil for incorrect data' do
        expect(Race.find_by_name('123')).to eq nil
      end
    end
  end
end
