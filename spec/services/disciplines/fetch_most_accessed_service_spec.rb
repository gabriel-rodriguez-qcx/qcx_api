RSpec.describe Disciplines::FetchMostAccessedService, type: :service do
  describe '#call' do
    subject(:call) { Disciplines::FetchMostAccessedService.call }

    let!(:question) { create :question }

    it 'returns an array of disciplines' do
      expect(subject).to be_an Array
      expect(subject.first).to be_a Discipline
    end

    it 'calls Disciplines::MostAccessedQuery' do
      expect(Disciplines::MostAccessedQuery).to receive(:call).and_return({})

      subject
    end
  end
end
