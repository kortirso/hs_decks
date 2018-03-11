RSpec.describe MultiClass, type: :model do
  it { should have_many :cards }
  it { should have_many :players }
  it { should validate_presence_of :name }

  it 'should be valid' do
    multi_class = create :multi_class

    expect(multi_class).to be_valid
  end

  context 'Methods' do
    let!(:multi_class) { create :multi_class }

    context '.locale_name' do
      it 'returns english name if arg is en' do
        expect(multi_class.locale_name('en')).to eq multi_class.name['en']
      end

      it 'returns russian name if arg is ru' do
        expect(multi_class.locale_name('ru')).to eq multi_class.name['ru']
      end
    end

    context '.find_by_locale_name' do
      it 'returns object if arg for en' do
        expect(MultiClass.find_by_locale_name('en', multi_class.name['en'])).to eq multi_class
      end

      it 'returns object if arg for ru' do
        expect(MultiClass.find_by_locale_name('ru', multi_class.name['ru'])).to eq multi_class
      end

      it 'returns nil for incorrect data' do
        expect(MultiClass.find_by_locale_name('ru', multi_class.name['en'])).to eq nil
      end
    end

    context '.find_by_name' do
      it 'returns object if arg is en' do
        expect(MultiClass.find_by_name(multi_class.name['en'])).to eq multi_class
      end

      it 'returns object if arg is ru' do
        expect(MultiClass.find_by_name(multi_class.name['ru'])).to eq multi_class
      end

      it 'returns nil for incorrect data' do
        expect(MultiClass.find_by_name('123')).to eq nil
      end
    end
  end
end
