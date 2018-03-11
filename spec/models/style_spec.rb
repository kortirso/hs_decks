RSpec.describe Style, type: :model do
  it { should have_many :decks }
  it { should validate_presence_of :name }

  it 'should be valid' do
    style = create :style

    expect(style).to be_valid
  end

  context 'Methods' do
    let!(:style) { create :style }

    context '.locale_name' do
      it 'returns english name if arg is en' do
        expect(style.locale_name('en')).to eq style.name['en']
      end

      it 'returns russian name if arg is ru' do
        expect(style.locale_name('ru')).to eq style.name['ru']
      end
    end

    context '.find_by_locale_name' do
      it 'returns object if arg for en' do
        expect(Style.find_by_locale_name('en', style.name['en'])).to eq style
      end

      it 'returns object if arg for ru' do
        expect(Style.find_by_locale_name('ru', style.name['ru'])).to eq style
      end

      it 'returns nil for incorrect data' do
        expect(Style.find_by_locale_name('ru', style.name['en'])).to eq nil
      end
    end

    context '.find_by_name' do
      it 'returns object if arg is en' do
        expect(Style.find_by_name(style.name['en'])).to eq style
      end

      it 'returns object if arg is ru' do
        expect(Style.find_by_name(style.name['ru'])).to eq style
      end

      it 'returns nil for incorrect data' do
        expect(Style.find_by_name('123')).to eq nil
      end
    end
  end
end
