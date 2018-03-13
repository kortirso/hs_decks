shared_examples_for 'Nameable' do
  context 'has class methods' do
    let!(:object) { nameable_object }

    context '.names_list' do
      it 'returns list of english names if arg is en' do
        expect(object.class.names_list('en')).to eq [object.name['en']]
      end

      it 'returns list of russian names if arg is ru' do
        expect(object.class.names_list('ru')).to eq [object.name['ru']]
      end
    end

    context '.find_by_locale_name' do
      it 'returns object if arg for en' do
        expect(object.class.find_by_locale_name('en', object.name['en'])).to eq object
      end

      it 'returns object if arg for ru' do
        expect(object.class.find_by_locale_name('ru', object.name['ru'])).to eq object
      end

      it 'returns nil for incorrect data' do
        expect(object.class.find_by_locale_name('ru', object.name['en'])).to eq nil
      end
    end

    context '.find_by_name' do
      it 'returns object if arg is en' do
        expect(object.class.find_by_name(object.name['en'])).to eq object
      end

      it 'returns object if arg is ru' do
        expect(object.class.find_by_name(object.name['ru'])).to eq object
      end

      it 'returns nil for incorrect data' do
        expect(object.class.find_by_name('123')).to eq nil
      end
    end
  end
end
