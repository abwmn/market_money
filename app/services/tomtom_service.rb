class TomtomService
  def self.nearest_atm(lat, lon)
    uri = URI("https://api.tomtom.com/search/2/categorySearch/ATM.json?lat=#{lat}&lon=#{lon}&key=#{ENV['TOMTOM_API_KEY']}")
    response = Net::HTTP.get(uri)
    atm_data = JSON.parse(response)

    atm_data['results'].map do |atm|
      {
        id: nil,
        type: 'atm',
        attributes: {
          name: atm['poi']['name'],
          address: atm['address']['freeformAddress'],
          lat: atm['position']['lat'],
          lon: atm['position']['lon'],
          distance: atm['dist']
        }
      }
    end
  end
end