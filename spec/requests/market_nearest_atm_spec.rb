require 'rails_helper'

RSpec.describe 'Market nearest ATM' do
  let!(:market) { create(:market) }

  context 'when the market exists' do
    before do
      VCR.use_cassette("nearest_atm") do
        get "/api/v0/markets/#{market.id}/nearest_atm"
      end
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns nearest atms' do
      json = JSON.parse(response.body)
      expect(json['data']).to be_an_instance_of(Array)
      expect(json['data'][0]['type']).to eq('atm')
    end
  end

  context 'when the market does not exist' do
    let(:market_id) { 123123123123 }

    before { get "/api/v0/markets/#{market_id}/nearest_atm" }

    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end

    it 'returns a not found message' do
      expect(response.body).to match(/Couldn't find Market with 'id'=123123123123/)
    end
  end
end