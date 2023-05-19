require 'rails_helper'

RSpec.describe "Vendors API", type: :request do
  describe 'Get One Vendor' do
    it 'returns the vendor when a valid vendor id is provided' do
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"
      
      expect(response).to have_http_status(200)

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:data][:id]).to eq(vendor.id.to_s)
      expect(parsed_response[:data][:attributes][:name]).to eq(vendor.name)
    end

    it 'returns a 404 and error message when vendor does not exist' do
      get '/api/v0/vendors/99999999'
      
      expect(response).to have_http_status(404)

      parsed_response = JSON.parse(response.body, symbolize_names: true)
      expect(parsed_response[:errors]).to be_present
    end
  end

  describe 'Create a vendor' do
    let(:valid_attributes) do
      {
        name: "Buzzy Bees",
        description: "local honey and wax products",
        contact_name: "Berly Couwer",
        contact_phone: "8389928383",
        credit_accepted: false
      }
    end

    context 'when the request is valid' do
      before { post '/api/v0/vendors', params: { vendor: valid_attributes } }

      it 'creates a vendor' do
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['name']).to eq('Buzzy Bees')
        expect(json['data']['attributes']['description']).to eq('local honey and wax products')
        expect(json['data']['attributes']['contact_name']).to eq('Berly Couwer')
        expect(json['data']['attributes']['contact_phone']).to eq('8389928383')
        expect(json['data']['attributes']['credit_accepted']).to eq(false)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      before { post '/api/v0/vendors', params: { vendor: { name: "Buzzy Bees", description: "local honey and wax products", credit_accepted: false } } }

      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end

      it 'returns a validation failure message' do
        json = JSON.parse(response.body)
        expect(json['errors'].first['message']).to include("Contact name can't be blank")
      end
    end
  end

  describe 'Update a vendor' do
    let(:vendor) { create(:vendor) }
    let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  
    context 'when the request is valid' do
      let(:valid_attributes) { { vendor: { contact_name: 'Kimberly Couwer', credit_accepted: false } }.to_json }
  
      before { patch "/api/v0/vendors/#{vendor.id}", params: valid_attributes, headers: headers }
  
      it 'updates the vendor' do
        json = JSON.parse(response.body)
        expect(json['data']['attributes']['contact_name']).to eq('Kimberly Couwer')
        expect(json['data']['attributes']['credit_accepted']).to be_falsey
      end
  
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end
  
    context 'when the request is invalid' do
      let(:invalid_attributes) { { vendor: { contact_name: '' } }.to_json }
  
      before { patch "/api/v0/vendors/#{vendor.id}", params: invalid_attributes, headers: headers }
  
      it 'returns status code 400' do
        expect(response).to have_http_status(400)
      end
  
      it 'returns a validation failure message' do
        json = JSON.parse(response.body)
        expect(json['errors'].first['message']).to include("Contact name can't be blank")
      end
    end
  
    context 'when the vendor does not exist' do
      let(:vendor_id) { 123123123123 }
  
      before { patch "/api/v0/vendors/#{vendor_id}", params: {}, headers: headers }
  
      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
  
      it 'returns a not found message' do
        json = JSON.parse(response.body)
        expect(json['errors'].first['message']).to include("Couldn't find Vendor")
      end
    end
  end

  describe 'DELETE /api/v0/vendors/:id' do
    let!(:vendor) { create(:vendor) }
  
    it 'deletes the vendor' do
      expect {
        delete "/api/v0/vendors/#{vendor.id}", headers: headers
      }.to change(Vendor, :count).by(-1)
      expect(response).to have_http_status(204)
    end
  
    it 'returns status code 404 when vendor does not exist' do
      delete "/api/v0/vendors/123123123123", headers: headers
      expect(response).to have_http_status(404)
      # require 'pry'; binding.pry
      json = JSON.parse(response.body)
      expect(json['errors'].first['message']).to eq("Couldn't find Vendor with 'id'=123123123123")
    end
  end
end
