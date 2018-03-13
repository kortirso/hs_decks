shared_examples_for 'Localizeable' do
  context 'has method .locale_name' do
    let!(:object) { nameable_object }

    it 'returns english name if arg is en' do
      expect(object.locale_name('en')).to eq object.name['en']
    end

    it 'returns russian name if arg is ru' do
      expect(object.locale_name('ru')).to eq object.name['ru']
    end
  end
end
