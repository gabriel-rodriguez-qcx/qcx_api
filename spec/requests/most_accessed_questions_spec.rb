RSpec.describe 'Most Accessed Questions', type: :request do
  describe 'GET /question_accesses' do
    let!(:question) { create :question }
    let!(:question_accesses) { create_list :question_access, 2, question: question, times_accessed: 20 }

    let!(:question2) { create :question }
    let!(:question2_accesses) { create_list :question_access, 2, question: question2, times_accessed: 30 }

    let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }
    let(:data) { parsed_body[:data] }
    let(:response_body) { response.body }

    let(:params) { { year: Time.zone.today.year.to_s } }

    it 'calls Questions::FetchMostAccessedService' do
      expect(Questions::FetchMostAccessedService)
        .to receive(:call)
        .with(year: params[:year], month: params[:month], week: params[:week])
        .and_call_original

      get v1_question_accesses_path, params: params
    end

    before(:each) do
      QuestionAccess.reindex

      get v1_question_accesses_path, params: params
    end

    it 'returns status 200 ok' do
      expect(response.status).to eq 200
    end

    it 'returns a json_api compliant body' do
      expect(response_body).to match_json_schema('question', strict: true)
    end

    it 'returns disciplines sorted by times_accesses' do
      expect(data.first[:id]).to eq question2.id.to_s
      expect(data.first[:attributes][:times_accessed]).to eq 60
      expect(data.second[:id]).to eq question.id.to_s
      expect(data.second[:attributes][:times_accessed]).to eq 40
    end

    context 'when filtering by year' do
      it 'returns meta' do
        expect(parsed_body[:meta][:year]).to eq params[:year]
        expect(parsed_body[:meta].keys).not_to include(:month)
        expect(parsed_body[:meta].keys).not_to include(:week)
      end
    end

    context 'when filtering by month' do
      it 'returns meta' do
        expect(parsed_body[:meta][:year]).to eq params[:year]
        expect(parsed_body[:meta][:month]).to eq params[:month]
        expect(parsed_body[:meta].keys).not_to include(:week)
      end
    end

    context 'when filtering by week' do
      it 'returns meta' do
        expect(parsed_body[:meta][:year]).to eq params[:year]
        expect(parsed_body[:meta].keys).not_to include(:month)
        expect(parsed_body[:meta][:week]).to eq params[:week]
      end
    end

    context 'when sending malformatted params' do
      %i[year month week].each do |param|
        let(:params) { { param => 'dwqdas' } }

        it { expect(response.status).to eq 422 }
        it { expect(parsed_body[:error]).to eq I18n.t('question_accesses_controller.errors.wrong_date_value') }
      end
    end

    context 'when year is not sent' do
      let(:params) { {} }

      it { expect(response.status).to eq 422 }
      it { expect(parsed_body[:error]).to eq I18n.t('question_accesses_controller.errors.presence') }
    end

    context 'when date is invalid' do
      %i[month week].each do |param|
        let(:params) { { param => '100' } }

        it { expect(response.status).to eq 422 }
        it { expect(parsed_body[:error]).to eq 'Invalid date' }
      end
    end
  end
end
