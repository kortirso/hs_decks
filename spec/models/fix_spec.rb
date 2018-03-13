RSpec.describe Fix, type: :model do
  it { should belong_to :about }
  it { should validate_presence_of :about_id }
  it { should validate_presence_of :body_en }
  it { should validate_presence_of :body_ru }

  it 'should be valid' do
    fix = create :fix

    expect(fix).to be_valid
  end

  describe 'Methods' do
    context '.locale_body' do
      let!(:fix) { create :fix }

      it 'returns english body if arg is en' do
        expect(fix.locale_body('en')).to eq fix.body_en
      end

      it 'returns russian body if arg is ru' do
        expect(fix.locale_body('ru')).to eq fix.body_ru
      end
    end
  end
end
