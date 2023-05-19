require 'rails_helper'

RSpec.describe 'Market search' do
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