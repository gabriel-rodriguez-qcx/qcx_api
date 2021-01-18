RSpec.describe Questions::Elastic::MostAccessedQuery, type: :query do
  describe '#call' do
    subject(:call) { Questions::Elastic::MostAccessedQuery.call(args) }

    let(:args) { { year: year, month: month, week: week } }
    let(:year) { Time.zone.today.year }
    let(:month) { nil }
    let(:week) { nil }

    let!(:question) { create :question }
    let!(:question_accesses_last_month) do
      create_list :question_access, 3, question: question, times_accessed: 1, date: Time.zone.today.end_of_year
    end

    let!(:question_accesses_first_week) do
      create_list :question_access, 2, question: question, times_accessed: 1, date: Date.commercial(year, 1)
    end

    let!(:question2) { create :question }
    let!(:question2_accesses_last_month) do
      create_list :question_access, 6, question: question2, times_accessed: 1, date: Time.zone.today.end_of_year
    end

    let!(:question2_accesses_first_week) do
      create_list :question_access, 5, question: question2, times_accessed: 1, date: Date.commercial(year, 1)
    end

    before(:each) { QuestionAccess.reindex }

    context 'when querying by week' do
      let(:week) { 1 }

      it 'returns question_ids sorted by times_accessed desc within chosen week' do
        expect(subject.first).to eq([question2.id, 5])
        expect(subject.to_a.second).to eq([question.id, 2])
      end
    end

    context 'when querying by month' do
      let(:month) { 12 }

      it 'returns question_ids sorted by times_accessed desc within chosen month' do
        expect(subject.first).to eq([question2.id, 6])
        expect(subject.to_a.second).to eq([question.id, 3])
      end
    end

    context 'when querying by year' do
      it 'returns question_ids sorted by times_accessed desc within chosen year' do
        expect(subject.first).to eq([question2.id, 11])
        expect(subject.to_a.second).to eq([question.id, 5])
      end
    end
  end
end
