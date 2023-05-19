require 'rails_helper'

RSpec.describe 'POST /api/v0/market_vendors', type: :request do
  let(:market) { create(:market) }
  let(:vendor) { create(:vendor) }

  let(:valid_attributes) { { market_id: market.id, vendor_id: vendor.id } }

  context 'when the request is valid' do
    before { post '/api/v0/market_vendors', params: valid_attributes, headers: headers }

    it 'creates a vendor market association' do
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json['message']).to eq('Successfully added vendor to market')
    end
  end

  context 'when the request is invalid' do
    before { post '/api/v0/market_vendors', params: { market_id: 123123123123, vendor_id: vendor.id }, headers: headers }

    it 'returns status code 404' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(404)
      expect(json['errors'].first['detail']).to eq("Validation failed: Market must exist or Vendor must exist")
    end
  end

  context 'when a duplicate request is made' do
    before do
      MarketVendor.create!(valid_attributes)
      post '/api/v0/market_vendors', params: valid_attributes, headers: headers
    end

    it 'returns status code 422' do
      json = JSON.parse(response.body)
      expect(response).to have_http_status(422)
      expect(json['errors'].first['detail']).to include('association between market and vendor already exists')
    end
  end
end
