RSpec.describe Disciplines::MostAccessedQuery, type: :query do
  describe '#call' do
    subject(:call) { Disciplines::MostAccessedQuery.call }

    let(:discipline) { 'programming 101' }
    let(:discipline2) { 'testing 101' }
    let!(:programming_questions) { create_list :question, 3, discipline: discipline, daily_access: 100 }
    let!(:testing_questions) { create_list :question, 2, discipline: discipline2, daily_access: 100 }

    it 'returns disciplines ordered by daily accesses sums' do
      expect(subject).to be_a Hash
      expect(subject.first).to eq([discipline, 300])
      expect(subject.to_a.second).to eq([discipline2, 200])
    end

    context 'when limit is defined' do
      subject(:call) { Disciplines::MostAccessedQuery.call(1) }
      it 'limits results returned' do
        expect(subject).to be_a Hash
        expect(subject.first).to eq([discipline, 300])
        expect(subject.size).to eq 1
      end
    end

    context 'when there are no question accesses' do
      let!(:programming_questions) { nil }
      let!(:testing_questions) { nil }

      it 'returns an empty hash' do
        expect(subject).to be_a Hash
        expect(subject).to be_empty
      end
    end
  end
end
