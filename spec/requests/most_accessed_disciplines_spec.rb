RSpec.describe 'Most Accessed Disciplines in last 24h hours', type: :request do
  describe 'GET /disciplines' do
    let!(:question) { create :question, daily_access: 10 }
    let!(:question2) { create :question, daily_access: 100 }

    before(:each) { get v1_disciplines_path }

    let(:parsed_body) { JSON.parse(response.body, symbolize_names: true) }
    let(:data) { parsed_body[:data] }
    let(:response_body) { response.body }

    it 'returns status 200 ok' do
      expect(response.status).to eq 200
    end

    it 'returns a json_api compliant body' do
      expect(response_body).to match_json_schema('discipline', strict: true)
    end

    it 'returns disciplines sorted by daily_accesses' do
      expect(data.first[:attributes][:name]).to eq question2.discipline
      expect(data.second[:attributes][:name]).to eq question.discipline
    end
  end
end
