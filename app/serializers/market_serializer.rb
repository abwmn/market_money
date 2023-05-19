class MarketSerializer
  include FastJsonapi::ObjectSerializer
  set_type :market  
  attributes :name, :street, :city, :county, :state, :zip, :lat, :lon
end
