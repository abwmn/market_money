class VendorSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :description, :contact_name, :contact_phone, :credit_accepted
end
