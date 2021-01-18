RSpec.describe Question, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many :question_accesses }
  end

  describe '#Validations' do
    it { is_expected.to validate_presence_of(:statement) }
    it { is_expected.to validate_presence_of(:text) }
    it { is_expected.to validate_presence_of(:answer) }
    it { is_expected.to validate_presence_of(:daily_access) }
    it { is_expected.to validate_presence_of(:discipline) }
    it { is_expected.to validate_inclusion_of(:answer).in_array(%w[A B C D]) }
  end
end
