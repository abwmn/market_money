require 'rails_helper'

RSpec.describe 'Markets API', type: :request do
  describe 'get all markets' do
    let!(:markets) { create_list(:market, 10) }
  
    before { get '/api/v0/markets' }
  
    it 'returns markets' do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json['data'].size).to eq(10)
      expect(json['data'].first['type']).to eq('market')
    end
  
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end  

  describe 'Get One Market' do
    it 'returns a market' do
      example = create(:market)
  
      get "/api/v0/markets/#{example.id}"
  
      expect(response).to be_successful
  
      market = JSON.parse(response.body, symbolize_names: true)
  
      expect(market[:data]).to have_key(:id)
      expect(market[:data]).to have_key(:type)
      expect(market[:data][:type]).to eq('market')
      expect(market[:data]).to have_key(:attributes)
      expect(market[:data][:attributes]).to have_key(:name)
      expect(market[:data][:attributes]).to have_key(:street)
      expect(market[:data][:attributes]).to have_key(:city)
      expect(market[:data][:attributes]).to have_key(:county)
      expect(market[:data][:attributes]).to have_key(:state)
      expect(market[:data][:attributes]).to have_key(:zip)
      expect(market[:data][:attributes]).to have_key(:lat)
      expect(market[:data][:attributes]).to have_key(:lon)
    end
  
    it 'returns a 404 and error message when market does not exist' do
      get '/api/v0/markets/99999999' 
  
      expect(response.status).to eq(404)
      expect(response.body).to match(/Couldn't find Market/)
    end
  end

  describe 'Get All Vendors for a Market' do
    it 'returns all vendors for a market' do
      market = create(:market)
      vendors = create_list(:vendor, 3)
      vendors.each do |vendor|
        create(:market_vendor, market: market, vendor: vendor)
      end
      
    
      get "/api/v0/markets/#{market.id}/vendors"
  
      expect(response).to be_successful
  
      vendors = JSON.parse(response.body, symbolize_names: true)
  
      expect(vendors[:data].length).to eq(3)
  
      vendors[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor).to have_key(:type)
        expect(vendor[:type]).to eq('vendor')
        expect(vendor).to have_key(:attributes)
        expect(vendor[:attributes]).to have_key(:name)
        expect(vendor[:attributes]).to have_key(:description)
        expect(vendor[:attributes]).to have_key(:contact_name)
        expect(vendor[:attributes]).to have_key(:contact_phone)
        expect(vendor[:attributes]).to have_key(:credit_accepted)
      end
    end
  
    it 'returns a 404 and error message when market does not exist' do
      get '/api/v0/markets/99999999/vendors' 
  
      expect(response.status).to eq(404)
      expect(response.body).to match(/Couldn't find Market/)
    end
  end

  describe 'GET /api/v0/markets/search' do
    let!(:market) { create(:market, name: 'Nob Hill Growers Market', city: 'Albuquerque', state: 'New Mexico') }
  
    context 'with valid parameters' do
      it 'returns the matching markets' do
        get '/api/v0/markets/search', params: { city: 'Albuquerque', state: 'New Mexico', name: 'Nob Hill Growers Market' }
        json = JSON.parse(response.body)
  
        expect(response).to have_http_status(200)
  
        expect(json['data'].first['name']).to eq('Nob Hill Growers Market')
      end
    end
  
    context 'with invalid parameters' do
      it 'returns an error' do
        get '/api/v0/markets/search', params: { city: 'Albuquerque' }
        json = JSON.parse(response.body)
  
        expect(response).to have_http_status(422)
  
        expect(json['errors'].first['detail']).to eq('Invalid set of parameters. Please provide a valid set of parameters to perform a search with this endpoint.')
      end
    end
  end
  
  
  describe 'GET /api/v0/markets/:id/nearest_atm' do
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
end
