describe DustPrice do
  context '.calc' do
    it 'should returns 0 if card rarity is Free' do
      expect(DustPrice.calc('Free', 1)).to eq 0
    end

    it 'should returns 40 if card rarity is Common' do
      expect(DustPrice.calc('Common', 1)).to eq 40
    end

    it 'should returns 100 if card rarity is Rare' do
      expect(DustPrice.calc('Rare', 1)).to eq 100
    end

    it 'should returns 400 if card rarity is Epic' do
      expect(DustPrice.calc('Epic', 1)).to eq 400
    end

    it 'should returns 1600 if card rarity is Legendary' do
      expect(DustPrice.calc('Legendary', 1)).to eq 1600
    end
  end
end
