RSpec.describe MultiClass, type: :model do
    it { should have_many :cards }
    it { should have_many :players }
end
