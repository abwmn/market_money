class VendorSerializer
  include FastJsonapi::ObjectSerializer
  set_type :vendor
  attributes :name, :description, :contact_name, :contact_phone, :credit_accepted
end
