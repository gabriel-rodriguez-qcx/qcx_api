RSpec.describe QuestionAccess, type: :model do
  describe '#Relationships' do
    it { is_expected.to belong_to :question }
  end

  describe '#Validations' do
    it { is_expected.to validate_presence_of(:times_accessed) }
    it { is_expected.to validate_presence_of(:date) }
  end
end
