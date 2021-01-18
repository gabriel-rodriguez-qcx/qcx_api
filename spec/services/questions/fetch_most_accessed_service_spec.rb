RSpec.describe Questions::FetchMostAccessedService, type: :service do
  describe '#call' do
    subject(:call) { Questions::FetchMostAccessedService.call(args) }

    let(:args) { { year: year, month: month, week: week } }
    let(:year) { question_accesses.first.date.year }
    let(:month) { nil }
    let(:week) { nil }

    let!(:question) { create :question }
    let!(:question_accesses) { create_list :question_access, 2, question: question, times_accessed: 1 }

    it 'returns questions' do
      expect(subject).to be_an Array
      expect(subject.first).to all(be_an(Question))
      expect(subject.first.first).to eq question
    end

    it 'returns access times' do
      expect(subject.last).to be_a Hash
      expect(subject.last).to include({ question.id => 2 })
    end

    it 'calls Disciplines::MostAccessedQuery' do
      expect(Questions::MostAccessedQuery).to receive(:call).with(args).and_call_original

      subject
    end
  end
end
